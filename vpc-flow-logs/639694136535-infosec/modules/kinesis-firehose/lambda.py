##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# This Lambda function processes VPC Flow Logs to identify and filter out internal traffic within the same VPC
# based on specified CIDR ranges, then formats and forwards only external traffic logs 
# (traffic leaving or entering the VPC) for further analysis or storage.
# VPC CIDR ranges must be passed as an environment variable (VPC_CIDR_RANGES) for accurate filtering.
# Example of dropped traffic: Communication from 172.31.18.14 to 172.31.3.31 within the 172.31.0.0/16 CIDR range.



import base64
import gzip
import logging
import os
import ipaddress
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

VPC_CIDR_RANGES = [cidr.strip() for cidr in os.environ.get('VPC_CIDR_RANGES', '').split(',') if cidr.strip()]
logger.info(f"Parsed VPC_CIDR_RANGES: {VPC_CIDR_RANGES}")

def is_gzipped(data):
    return data[:2] == b'\x1f\x8b'

# Map fields for VPC Flow Logs
def parse_vpc_flow_log_entry(log_entry_text):
    fields = log_entry_text.strip().split()
    if len(fields) < 14:
        logger.error(f"Incomplete log entry: {log_entry_text}")
        return None
    
    return {
        'version': fields[0],
        'account-id': fields[1],
        'interface-id': fields[2],
        'srcaddr': fields[3],
        'dstaddr': fields[4],
        'srcport': fields[5],
        'dstport': fields[6],
        'protocol': fields[7],
        'packets': fields[8],
        'bytes': fields[9],
        'start': fields[10],
        'end': fields[11],
        'action': fields[12],
        'log-status': fields[13]
    }

# Check if traffic is internal based on CIDR ranges
def is_internal_traffic(srcaddr, dstaddr):
    try:
        src_ip = ipaddress.ip_address(srcaddr)
        dst_ip = ipaddress.ip_address(dstaddr)
    except ValueError as e:
        logger.error(f"Invalid IP address in log entry - srcaddr: {srcaddr}, dstaddr: {dstaddr} - Error: {e}")
        return False

    for cidr in VPC_CIDR_RANGES:
        try:
            network = ipaddress.ip_network(cidr)
            if src_ip in network and dst_ip in network:
                logger.info(f"Both {srcaddr} and {dstaddr} are within CIDR {cidr}. Dropping log entry as internal traffic.")
                return True
        except ValueError as e:
            logger.error(f"Invalid CIDR in VPC_CIDR_RANGES: {cidr} - Error: {e}")
            continue
    return False

def lambda_handler(event, context):
    logger.info("Received event with %d records", len(event.get('records', [])))
    
    output_records = []
    
    for record in event.get('records', []):
        try:
            # Decode the base64 data
            decoded_data = base64.b64decode(record['data'])

            # Decompress if gzipped
            if is_gzipped(decoded_data):
                uncompressed_data = gzip.decompress(decoded_data).decode('utf-8')
            else:
                uncompressed_data = decoded_data.decode('utf-8')

            # Process each line in uncompressed data
            for line in uncompressed_data.strip().splitlines():
                log_entry = parse_vpc_flow_log_entry(line)
                
                if not log_entry:
                    continue  
                
                # Check if the entry is internal or external traffic
                if log_entry['srcaddr'] == '-' or log_entry['dstaddr'] == '-':
                    logger.info(f"Skipped log entry with incomplete IPs: {line}")
                    continue
                
                if is_internal_traffic(log_entry['srcaddr'], log_entry['dstaddr']):
                    # Log internal traffic as dropped
                    logger.info(f"Dropped internal traffic from {log_entry['srcaddr']} to {log_entry['dstaddr']}")
                    continue
                else:
                    # Log external traffic as processed
                    logger.info(f"Processed external traffic from {log_entry['srcaddr']} to {log_entry['dstaddr']}")
                
                # Transform to JSON format and encode back to base64
                transformed_data = json.dumps(log_entry).encode('utf-8')
                encoded_data = base64.b64encode(transformed_data).decode('utf-8')
                
               
                output_records.append({
                    'recordId': record['recordId'],
                    'result': 'Ok',
                    'data': encoded_data
                })
        
        except Exception as e:
            logger.error(f"Unexpected error processing record {record['recordId']}: {e}")
            output_records.append({
                'recordId': record['recordId'],
                'result': 'ProcessingFailed',
                'data': record['data']
            })
    
    return {'records': output_records}
