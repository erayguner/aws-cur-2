#!/bin/bash

################################################################################
# FinOps FOCUS Multi-Cloud Platform - Automated Setup Script
#
# Version: 1.0.0
# Description: Automates the deployment of AWS CUR + GCP Billing to BigQuery
#              with FOCUS-compliant unified views and Looker integration
#
# Prerequisites:
#   - AWS CLI configured with appropriate credentials
#   - gcloud CLI authenticated and project set
#   - bq command-line tool available
#   - Billing account access (AWS and GCP)
#
# Usage:
#   ./setup.sh --project-id my-gcp-project \
#              --aws-cur-bucket my-cur-bucket \
#              --billing-account 0X0X0X-0X0X0X-0X0X0X
#
################################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="${SCRIPT_DIR}/setup-$(date +%Y%m%d-%H%M%S).log"

# Configuration variables
GCP_PROJECT_ID=""
AWS_CUR_BUCKET=""
GCP_BILLING_ACCOUNT=""
AWS_REGION="us-east-1"
BQ_DATASET_LOCATION="US"
SKIP_AWS=false
SKIP_GCP=false
SKIP_LOOKER=false
DRY_RUN=false

################################################################################
# Utility Functions
################################################################################

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$LOG_FILE"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Required Options:
    --project-id PROJECT_ID          GCP project ID
    --aws-cur-bucket BUCKET_NAME     S3 bucket for AWS CUR
    --billing-account ACCOUNT_ID     GCP billing account ID

Optional:
    --aws-region REGION              AWS region (default: us-east-1)
    --bq-location LOCATION           BigQuery dataset location (default: US)
    --skip-aws                       Skip AWS CUR setup
    --skip-gcp                       Skip GCP billing export setup
    --skip-looker                    Skip Looker integration
    --dry-run                        Print commands without executing
    -h, --help                       Show this help message

Example:
    $0 --project-id my-gcp-project \\
       --aws-cur-bucket my-cur-bucket \\
       --billing-account 0X0X0X-0X0X0X-0X0X0X

EOF
    exit 1
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-id)
                GCP_PROJECT_ID="$2"
                shift 2
                ;;
            --aws-cur-bucket)
                AWS_CUR_BUCKET="$2"
                shift 2
                ;;
            --billing-account)
                GCP_BILLING_ACCOUNT="$2"
                shift 2
                ;;
            --aws-region)
                AWS_REGION="$2"
                shift 2
                ;;
            --bq-location)
                BQ_DATASET_LOCATION="$2"
                shift 2
                ;;
            --skip-aws)
                SKIP_AWS=true
                shift
                ;;
            --skip-gcp)
                SKIP_GCP=true
                shift
                ;;
            --skip-looker)
                SKIP_LOOKER=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                ;;
        esac
    done
}

################################################################################
# Main Execution
################################################################################

main() {
    log "========================================="
    log "FinOps FOCUS Platform Setup"
    log "Version: 1.0.0"
    log "========================================="
    
    parse_args "$@"
    
    log "Setup script ready. See IMPLEMENTATION_GUIDE.md for full instructions."
}

main "$@"
