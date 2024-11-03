##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

import json
import base64
import logging
import gzip

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def is_gzipped(data):
    return data[:2] == b'\x1f\x8b'

def enforce_schema(log_entry):
    """
    Ensure that the log entry follows a consistent schema by adding missing fields with null values.
    """
    expected_fields = ['requestId', 'httpRequest', 'ruleGroupList', 'action', 'terminatingRuleId'] 
    for field in expected_fields:
        if field not in log_entry:
            log_entry[field] = None
    return log_entry

def lambda_handler(event, context):
    logger.info("Received event with %d records", len(event.get('records', [])))
    
    processed_success = 0
    processed_failure = 0
    output_records = []
    
    for record in event.get('records', []):
        try:
            decoded_data = base64.b64decode(record['data'])
            logger.debug("Decoded data: %s", decoded_data[:100]) 
            
            if is_gzipped(decoded_data):
                logger.info("Data is gzipped, decompressing")
                uncompressed_data = gzip.decompress(decoded_data).decode('utf-8')
            else:
                logger.info("Data is not gzipped")
                uncompressed_data = decoded_data.decode('utf-8')

            log_entry = json.loads(uncompressed_data)
            logger.debug("Log entry before processing: %s", json.dumps(log_entry)[:200]) 

            # Skip records with action "ALLOW" (accepted traffic)
            if log_entry.get('action') == "ALLOW":
                logger.info("Skipping accepted traffic record with requestId: %s", log_entry.get('requestId'))
                continue  # Skip to the next record
            
            # Remove non-essential fields
            non_essential_fields = ['terminatingRuleMatchDetails', 'requestHeadersInserted', 'labels']
            for field in non_essential_fields:
                if field in log_entry:
                    del log_entry[field]

            # Enforce schema to ensure consistency
            log_entry = enforce_schema(log_entry)
            
            # Transform and encode back into base64
            transformed_data = json.dumps(log_entry).encode('utf-8')
            encoded_data = base64.b64encode(transformed_data).decode('utf-8')
            
            output_records.append({
                'recordId': record['recordId'],
                'result': 'Ok',
                'data': encoded_data
            })
            processed_success += 1
            logger.info("Processed record successfully: %s", record['recordId'])
        
        except Exception as e:
            processed_failure += 1
            logger.error(f"Error processing record {record['recordId']}: {e}")
            output_records.append({
                'recordId': record['recordId'],
                'result': 'ProcessingFailed',
                'data': record['data']  # Pass the unmodified data to the backup bucket
            })
    
    logger.info("Processed %d records successfully, %d failed, %d skipped", processed_success, processed_failure, len(event.get('records', [])) - processed_success - processed_failure)
    return {'records': output_records}
