##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "athena_workgroup_name" {
  description = "The name of the Athena workgroup"
  value       = aws_athena_workgroup.workgroup.name
}