# Resource-Type Operational Dashboards - Comprehensive Design
# Beyond Cost: Service-Specific Insights for AWS Resources

**Document Version:** 1.0  
**Created:** 2025-11-17  
**Research Scope:** Next 10 years (2025-2035)  
**Focus:** Operational metrics beyond cost analysis  

---

## Executive Summary

This document provides comprehensive research and design recommendations for **Resource-Type Operational Dashboards** focused on service-specific insights beyond cost metrics. While AWS Cost and Usage Reports (CUR) excel at financial analysis, operational health, performance, and resource lifecycle management require integration with CloudWatch, AWS Config, Performance Insights, and other operational data sources.

### Key Differentiation from Cost Dashboards

| Aspect | Cost Dashboards (CUR-based) | Operational Dashboards (This Document) |
|--------|----------------------------|----------------------------------------|
| **Primary Data Source** | AWS CUR 2.0 | CloudWatch Metrics, AWS Config, Performance Insights, X-Ray |
| **Primary Focus** | Spend analysis, optimization savings | Performance, health, capacity, quality |
| **Key Metrics** | Unblended cost, commitments, discounts | CPU%, latency, error rates, saturation |
| **Update Frequency** | Hourly/daily (billing data) | Real-time to 1-minute intervals |
| **Primary Users** | FinOps, Finance, Executives | Engineers, SREs, DevOps, Platform teams |
| **Action Outcomes** | Cost reduction, commitment purchases | Performance tuning, capacity planning, incident response |

### Integration Strategy

**Recommended Approach:** Create operational dashboards that can be **correlated with cost data** from CUR for comprehensive resource intelligence:

```
Operational Dashboard (CloudWatch) + Cost Attribution (CUR) = Complete Resource Intelligence
```

For example:
- Identify high-CPU EC2 instances (CloudWatch) → Check their hourly cost (CUR) → Determine if right-sizing or instance type change is warranted
- Track Lambda cold starts (CloudWatch) → Correlate with provisioned concurrency cost (CUR) → Optimize performance vs. cost tradeoff

---

## 1. COMPUTE DASHBOARDS

### 1.1 EC2 Operational Dashboard

**Data Sources:** CloudWatch, EC2 API, Systems Manager, CloudWatch Agent

#### Critical Operational Metrics

**Instance Health & Availability**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| StatusCheckFailed | CloudWatch (default) | 1 minute | > 0 |
| InstanceStatus | CloudWatch (default) | 1 minute | "impaired" |
| SystemStatus | CloudWatch (default) | 1 minute | "impaired" |
| ScheduledMaintenanceEvents | EC2 API | Daily | > 0 upcoming events |
| Instance Uptime | CloudWatch Agent | 1 minute | < expected SLA |

**CPU Performance**
| Metric | Source | Update Frequency | Optimization Threshold |
|--------|--------|------------------|------------------------|
| CPUUtilization | CloudWatch (default) | 1/5 minutes | > 80% sustained, < 20% underutilized |
| CPUCreditBalance (T2/T3) | CloudWatch (default) | 5 minutes | < 10 credits remaining |
| CPUCreditUsage (T2/T3) | CloudWatch (default) | 5 minutes | Trending toward depletion |
| vCPU Usage per Core | CloudWatch Agent | 1 minute | Uneven distribution |

**Memory Utilization** (Requires CloudWatch Agent)
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| mem_used_percent | CloudWatch Agent | 1 minute | > 85% |
| mem_available | CloudWatch Agent | 1 minute | < 2 GB |
| swap_used_percent | CloudWatch Agent | 1 minute | > 50% (indicates memory pressure) |

**Disk I/O & Storage**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| DiskReadOps | CloudWatch (default) | 5 minutes | Baseline deviation > 3σ |
| DiskWriteOps | CloudWatch (default) | 5 minutes | Baseline deviation > 3σ |
| DiskReadBytes | CloudWatch (default) | 5 minutes | Approaching EBS limits |
| DiskWriteBytes | CloudWatch (default) | 5 minutes | Approaching EBS limits |
| disk_used_percent | CloudWatch Agent | 1 minute | > 80% |
| disk_inodes_free | CloudWatch Agent | 1 minute | < 10% |

**Network Performance**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| NetworkIn | CloudWatch (default) | 5 minutes | Approaching instance network limit |
| NetworkOut | CloudWatch (default) | 5 minutes | Approaching instance network limit |
| NetworkPacketsIn | CloudWatch (default) | 5 minutes | Packet loss indicators |
| NetworkPacketsOut | CloudWatch (default) | 5 minutes | Packet loss indicators |

#### Resource Lifecycle Tracking

**Instance Age & Staleness**
```sql
-- Correlated with CUR data
SELECT 
  line_item_resource_id,
  DATEDIFF(day, MIN(line_item_usage_start_date), CURRENT_DATE) as instance_age_days,
  CASE 
    WHEN DATEDIFF(day, MIN(line_item_usage_start_date), CURRENT_DATE) > 730 THEN 'Very Old (2+ years)'
    WHEN DATEDIFF(day, MIN(line_item_usage_start_date), CURRENT_DATE) > 365 THEN 'Old (1-2 years)'
    WHEN DATEDIFF(day, MIN(line_item_usage_start_date), CURRENT_DATE) > 180 THEN 'Aging (6-12 months)'
    ELSE 'Recent'
  END as staleness_category
FROM cur2
WHERE line_item_product_code = 'AmazonEC2'
  AND line_item_line_item_type = 'Usage'
  AND line_item_resource_id IS NOT NULL
GROUP BY line_item_resource_id
```

**Orphaned Resource Detection**
- EBS volumes not attached to instances (AWS Config rule)
- Elastic IPs not associated with running instances
- Snapshots older than retention policy
- AMIs not used in 90+ days
- Security groups with no attached resources

#### Dashboard Layout

**Executive View (Top Row)**
```
┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
│ Total Instances │ Healthy         │ CPU Avg (Fleet) │ Memory Avg      │
│ 1,247           │ 1,245 (99.8%)   │ 42%             │ 58%             │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┘
```

**Health Status Table**
| Instance ID | Type | AZ | Status | CPU% | Memory% | Disk% | Network (Mbps) | Age (days) | Tags Complete |
|-------------|------|----|----|------|---------|-------|----------------|------------|---------------|
| i-abc123 | m5.large | us-east-1a | OK | 45% | 62% | 38% | 125 / 10,000 | 87 | ✓ |
| i-def456 | t3.medium | us-east-1b | ⚠️ CPU | 92% | 48% | 52% | 89 / 5,000 | 412 | ✗ |

**Performance Time Series**
- CPU utilization trend (last 24h, 7d, 30d)
- Memory utilization trend
- Network throughput trend
- Disk I/O operations trend

**Right-Sizing Recommendations**
| Instance | Current Type | CPU Avg | Memory Avg | Recommendation | Potential Savings |
|----------|--------------|---------|------------|----------------|-------------------|
| i-abc123 | m5.2xlarge | 15% | 22% | Downsize to m5.large | $85/mo |
| i-def456 | t3.small | 95% | 88% | Upgrade to t3.medium | Better performance |

---

### 1.2 Lambda Operational Dashboard

**Data Sources:** CloudWatch Lambda Metrics, CloudWatch Logs Insights, X-Ray

#### Critical Operational Metrics

**Invocation Metrics**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| Invocations | 1 minute | Baseline deviation |
| Errors | 1 minute | > 1% error rate |
| Throttles | 1 minute | > 0 |
| DeadLetterErrors | 1 minute | > 0 |
| DestinationDeliveryFailures | 1 minute | > 0 |

**Performance Metrics**
| Metric | Update Frequency | Percentile | Alert Threshold |
|--------|------------------|------------|-----------------|
| Duration | 1 minute | p50, p90, p99 | p99 > timeout - 1s |
| InitDuration (Cold Starts) | 1 minute | p50, p90, p99 | p90 > 3s |
| IteratorAge (streams) | 1 minute | Max | > 60s |

**Concurrency Metrics**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| ConcurrentExecutions | 1 minute | > 80% of reserved concurrency |
| ProvisionedConcurrentExecutions | 1 minute | Track utilization |
| ProvisionedConcurrencySpilloverInvocations | 1 minute | > 0 (indicates provisioning too low) |
| UnreservedConcurrentExecutions | 1 minute | Approaching account limit |

**Cost-Correlated Operational Metrics**
| Metric | Calculation | Business Impact |
|--------|-------------|-----------------|
| Cold Start Rate | InitDuration events / Total invocations | User experience degradation |
| Cost per Invocation | Total Lambda cost (CUR) / Invocations | Unit economics |
| Cost per Duration (GB-second) | Lambda cost / (Memory × Duration) | Efficiency metric |
| Provisioned Concurrency Waste | (Provisioned - Used) × Cost | Overspending indicator |

#### Dashboard Layout

**Executive View**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total Functions  │ Invocations (24h)│ Error Rate       │ Cold Start %     │
│ 342              │ 24.8M            │ 0.03%            │ 2.1%             │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Function Health Table**
| Function Name | Invocations | Errors | Throttles | Duration (p99) | Cold Starts | Memory | Daily Cost |
|---------------|-------------|--------|-----------|----------------|-------------|--------|------------|
| api-handler | 1.2M | 12 (0.001%) | 0 | 245ms | 1.8% | 512 MB | $8.42 |
| data-processor | 340K | 1,823 (0.54%) | 142 | 4,821ms | 0.2% | 3008 MB | $124.18 |

**Cold Start Analysis**
| Function | Runtime | Package Size | Init Duration (p90) | Recommendation |
|----------|---------|--------------|---------------------|----------------|
| java-api | Java 11 | 45 MB | 8,234ms | Consider Lambda SnapStart |
| node-api | Node.js 20 | 2.3 MB | 128ms | OK |
| python-ml | Python 3.11 | 250 MB | 12,456ms | Enable Provisioned Concurrency |

---

### 1.3 ECS/EKS Container Operational Dashboard

**Data Sources:** CloudWatch Container Insights, Kubernetes API, Prometheus

#### Critical Operational Metrics

**Cluster Health**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| ClusterFailedNodeCount | Container Insights | 1 minute | > 0 |
| NodeCount | Container Insights | 1 minute | Below minimum |
| cluster_failed_node_count | Prometheus | 15 seconds | > 0 |

**Pod/Container Health**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| pod_number_of_container_restarts | Container Insights | 1 minute | > 3 in 5 min |
| PodStatus (Pending/Failed) | Kubernetes API | Real-time | > 0 for critical workloads |
| container_cpu_utilization | Container Insights | 1 minute | > 80% |
| container_memory_utilization | Container Insights | 1 minute | > 85% |

**Deployment Tracking**
| Metric | Source | Update Frequency | Business Value |
|--------|--------|------------------|----------------|
| Deployment Frequency | Kubernetes Events | Real-time | DORA metric |
| Deployment Duration | Kubernetes Events | Real-time | Lead time metric |
| Rollback Events | Kubernetes Events | Real-time | Quality indicator |
| ReplicaSet Scaling Events | Kubernetes API | Real-time | Capacity planning |

**Resource Efficiency**
| Metric | Calculation | Optimization Target |
|--------|-------------|---------------------|
| Pod Density | Pods per Node | Maximize within limits |
| CPU Request Utilization | Actual CPU / Requested CPU | 70-90% |
| Memory Request Utilization | Actual Mem / Requested Mem | 70-90% |
| Node Utilization | Used Resources / Total Resources | > 65% |

#### Dashboard Layout

**Cluster Overview**
```
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│ Clusters    │ Nodes       │ Pods        │ CPU %       │ Memory %    │
│ 8           │ 142 (142)   │ 1,847       │ 58%         │ 62%         │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

**Workload Health Table**
| Namespace | Deployment | Pods | Restarts (1h) | CPU % | Memory % | Network (Mbps) | Storage (GB) |
|-----------|------------|------|---------------|-------|----------|----------------|--------------|
| production | api-service | 12/12 | 0 | 42% | 58% | 1,245 | 89 |
| production | worker | 8/8 | 2 | 78% | 81% | 234 | 142 |
| staging | test-app | 3/5 | 15 | 12% | 24% | 12 | 8 |

**Deployment Tracking**
| Deployment | Frequency (7d) | Avg Duration | Success Rate | Last Rollback |
|------------|----------------|--------------|--------------|---------------|
| api-service | 14 | 3m 42s | 100% | None |
| worker | 8 | 8m 12s | 87.5% | 2 days ago |

---

## 2. STORAGE DASHBOARDS

### 2.1 S3 Storage Operational Dashboard

**Data Sources:** S3 Storage Lens, S3 Inventory, CloudWatch S3 Metrics, S3 Analytics

#### Critical Operational Metrics

**Storage Analytics**
| Metric | Source | Update Frequency | Business Value |
|--------|--------|------------------|----------------|
| BucketSizeBytes | CloudWatch | Daily | Capacity planning |
| NumberOfObjects | CloudWatch | Daily | Scale tracking |
| AllRequests | CloudWatch (request metrics) | 1 minute | Traffic analysis |
| GetRequests | CloudWatch | 1 minute | Read pattern analysis |
| PutRequests | CloudWatch | 1 minute | Write pattern analysis |

**Access Pattern Metrics**
| Metric | Source | Update Frequency | Optimization Use |
|--------|--------|------------------|------------------|
| Days Since Last Access | S3 Storage Lens | Daily | Lifecycle policy optimization |
| Access Frequency | S3 Analytics | Daily | Storage class recommendations |
| Retrieval Pattern | CloudWatch | 1 minute | Caching opportunities |
| Cross-Region Requests | S3 Access Logs | Hourly | Replication strategy |

**Lifecycle & Tiering Effectiveness**
| Metric | Source | Calculation | Target |
|--------|--------|-------------|--------|
| Intelligent-Tiering Savings | S3 Storage Lens | Cost reduction vs. Standard | > 20% for qualifying data |
| Lifecycle Transition Rate | S3 Inventory | Objects transitioned / Total | Aligned with access patterns |
| Glacier Retrieval Cost | CUR + S3 Metrics | Retrieval cost / Storage savings | < 10% of savings |
| Versioning Overhead | S3 Storage Lens | Version size / Current size | < 30% |

**Data Quality & Compliance**
| Metric | Source | Alert Threshold |
|--------|--------|-----------------|
| DeleteMarkers | S3 Inventory | > 1M (cleanup needed) |
| Incomplete Multipart Uploads | S3 Inventory | > 100 |
| Non-Current Versions (age) | S3 Inventory | > 90 days |
| Encryption Coverage | S3 Storage Lens | < 100% for sensitive buckets |
| Replication Lag | CloudWatch | > 15 minutes |

#### Dashboard Layout

**Storage Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total Buckets    │ Total Objects    │ Total Size       │ Requests (24h)   │
│ 487              │ 2.8B             │ 842 TB           │ 124M             │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Bucket Health Table**
| Bucket | Objects | Size (TB) | Storage Class Mix | Avg Days Since Access | Versioning Overhead | Encryption | Replication |
|--------|---------|-----------|-------------------|----------------------|---------------------|------------|-------------|
| prod-data | 1.2B | 421 | 45% Std, 35% IA, 20% Glacier | 87 | 12% | AES-256 | ✓ |
| logs-archive | 840M | 318 | 15% IA, 85% Glacier | 342 | 0% | KMS | ✗ |

**Access Pattern Analysis**
| Bucket | GET Req (24h) | PUT Req (24h) | Access Pattern | Recommended Class | Potential Savings |
|--------|---------------|---------------|----------------|-------------------|-------------------|
| prod-data | 12.4M | 340K | Hot/Warm mixed | Intelligent-Tiering | $8,400/mo |
| legacy-files | 124 | 8 | Cold | Glacier Instant | $12,200/mo |

**Intelligent-Tiering Effectiveness**
| Bucket | Objects in IT | Frequent Tier | Infrequent Tier | Archive Instant | Archive Access | Savings (30d) |
|--------|---------------|---------------|-----------------|-----------------|----------------|---------------|
| analytics | 340M | 15% | 45% | 30% | 10% | $24,800 |

---

### 2.2 EBS Operational Dashboard

**Data Sources:** CloudWatch EBS Metrics, EBS Volume API

#### Critical Operational Metrics

**Volume Performance**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| VolumeReadOps | 1 minute | Approaching IOPS limit |
| VolumeWriteOps | 1 minute | Approaching IOPS limit |
| VolumeReadBytes | 1 minute | Approaching throughput limit |
| VolumeWriteBytes | 1 minute | Approaching throughput limit |
| VolumeQueueLength | 1 minute | > 10 (indicates saturation) |
| VolumeThroughputPercentage | 1 minute | > 95% |
| VolumeConsumedReadWriteOps | 1 minute | Track burst balance usage |

**Volume Health**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| VolumeIdleTime | 5 minutes | 100% (unused volume) |
| VolumeBurstBalance | 5 minutes | < 20% (gp2/gp3 only) |
| VolumeStalledIOCheck | 5 minutes | True (critical) |

**Orphaned Volume Detection**
```
Available volumes not attached to instances > 7 days
Snapshots older than retention policy
Volumes from terminated instances
```

---

### 2.3 EFS Operational Dashboard

**Data Sources:** CloudWatch EFS Metrics

#### Critical Operational Metrics

**File System Performance**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| DataReadIOBytes | 1 minute | Baseline deviation |
| DataWriteIOBytes | 1 minute | Baseline deviation |
| MetadataIOBytes | 1 minute | High metadata activity |
| PercentIOLimit | 1 minute | > 95% (I/O saturation) |
| PermittedThroughput | 1 minute | Track bursting |
| TotalIOBytes | 1 minute | Trend analysis |

**Storage Metrics**
| Metric | Update Frequency | Business Value |
|--------|------------------|----------------|
| StorageBytes (Standard) | Daily | Capacity planning |
| StorageBytes (IA) | Daily | Lifecycle effectiveness |
| StorageBytes (Archive) | Daily | Cold data management |

---

## 3. DATABASE DASHBOARDS

### 3.1 RDS Operational Dashboard

**Data Sources:** RDS Performance Insights (until June 2026), CloudWatch Database Insights (post-Nov 2025), Enhanced Monitoring, CloudWatch

**⚠️ Important 2025-2026 Transition:**
- **Performance Insights EOL:** June 30, 2026
- **Migration Path:** CloudWatch Database Insights (expanded capabilities)
- **Recommendation:** Design dashboards with Database Insights going forward

#### Critical Operational Metrics

**Database Load (DBLoad)**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| DBLoad (AAS) | Database Insights | 1 second | > vCPU count |
| DBLoadCPU | Database Insights | 1 second | > 80% of DBLoad |
| DBLoadNonCPU | Database Insights | 1 second | > 20% of DBLoad |

**Query Performance**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| Top SQL by DBLoad | Database Insights | Real-time | Individual query > 10% DBLoad |
| Slow Query Count | CloudWatch Logs | 1 minute | Increasing trend |
| ReadLatency | CloudWatch | 1 minute | > 10ms (SSD) |
| WriteLatency | CloudWatch | 1 minute | > 10ms (SSD) |

**Connection Management**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| DatabaseConnections | CloudWatch | 1 minute | > 80% of max_connections |
| LoginFailures | Enhanced Monitoring | 1 minute | > 5/minute |
| Deadlocks | Enhanced Monitoring | 1 minute | > 0 |
| TransactionLogsDiskUsage | CloudWatch | 5 minutes | > 75% |

**Replication Health**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| ReplicaLag | CloudWatch | 1 minute | > 30 seconds |
| BinLogDiskUsage (MySQL) | CloudWatch | 5 minutes | > 80% |
| OldestReplicationSlotLag (PostgreSQL) | CloudWatch | 1 minute | > 1GB |

**Backup Status**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| BackupRetentionPeriodStorageUsed | CloudWatch | Daily | Approaching limit |
| SnapshotStorageUsed | CloudWatch | Daily | Trend analysis |
| Last Backup Age | API | Hourly | > 25 hours (daily backups) |

**Resource Utilization**
| Metric | Source | Update Frequency | Alert Threshold |
|--------|--------|------------------|-----------------|
| CPUUtilization | CloudWatch | 1 minute | > 80% |
| FreeableMemory | CloudWatch | 1 minute | < 10% |
| FreeStorageSpace | CloudWatch | 5 minutes | < 20% |
| DiskQueueDepth | CloudWatch | 1 minute | > 10 |
| SwapUsage | Enhanced Monitoring | 1 minute | > 0 (indicates memory pressure) |

#### Dashboard Layout

**Database Fleet Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total Instances  │ DBLoad Avg       │ Connections      │ Replica Lag Avg  │
│ 87               │ 3.2 AAS          │ 1,247 / 2,000    │ 1.2s             │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Instance Health Table**
| Instance | Engine | DBLoad (AAS) | CPU% | Memory% | Storage% | Connections | Replica Lag | IOPS Used | Top Wait Event |
|----------|--------|--------------|------|---------|----------|-------------|-------------|-----------|----------------|
| prod-db-01 | PostgreSQL 15 | 5.8 | 72% | 81% | 58% | 342/500 | N/A (primary) | 8,400/10,000 | CPU |
| prod-db-02 | PostgreSQL 15 | 2.1 | 28% | 45% | 58% | 124/500 | 0.8s | 2,100/10,000 | IO:DataFileRead |

**Top SQL Analysis**
| Query Digest | DBLoad Contribution | Calls/sec | Avg Latency | Rows/Call | Recommendation |
|--------------|---------------------|-----------|-------------|-----------|----------------|
| SELECT * FROM orders WHERE... | 18.2% | 1,240 | 142ms | 1 | Add index on order_date |
| UPDATE inventory SET... | 12.4% | 89 | 2,341ms | 1,200 | Batch updates |

**Replication Health**
| Primary | Read Replica | Lag (seconds) | Lag (bytes) | Last Error | Status |
|---------|--------------|---------------|-------------|------------|--------|
| prod-db-01 | prod-db-02 | 0.8 | 124 MB | None | ✓ Healthy |
| prod-db-01 | prod-db-03 | 45.2 | 8.2 GB | Replication slot overflow | ⚠️ Warning |

---

### 3.2 DynamoDB Operational Dashboard

**Data Sources:** CloudWatch DynamoDB Metrics, DynamoDB Contributor Insights, CUR

**🆕 2025 Enhancements:**
- 8 new throttling metrics (read/write for 4 throttling types)
- Throttled-keys-only mode for Contributor Insights (cost-effective)

#### Critical Operational Metrics

**Capacity & Throttling**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| ConsumedReadCapacityUnits | 1 minute | > 80% of provisioned (provisioned mode) |
| ConsumedWriteCapacityUnits | 1 minute | > 80% of provisioned (provisioned mode) |
| UserErrors (Throttling) | 1 minute | > 0 |
| SystemErrors | 1 minute | > 0 |

**New 2025 Throttling Metrics:**
| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| ReadThrottleEvents | Reads throttled (any reason) | > 0 |
| WriteThrottleEvents | Writes throttled (any reason) | > 0 |
| AccountMaxTableLevelReads | Throttled due to account limits | > 0 (contact AWS) |
| AccountMaxTableLevelWrites | Throttled due to account limits | > 0 (contact AWS) |
| MaxProvisionedTableReadCapacityUtilization | Throttled on provisioned capacity | > 0 (increase capacity) |
| MaxProvisionedTableWriteCapacityUtilization | Throttled on provisioned capacity | > 0 (increase capacity) |

**GSI/LSI Monitoring**
| Metric | Dimension | Alert Threshold |
|--------|-----------|-----------------|
| OnlineIndexConsumedWriteCapacity | GSI name | > 80% of GSI capacity |
| OnlineIndexThrottleEvents | GSI name | > 0 |
| OnlineIndexPercentageProgress | GSI name | < 100% for building indexes |

**Performance Metrics**
| Metric | Update Frequency | Optimization Target |
|--------|------------------|---------------------|
| SuccessfulRequestLatency | 1 minute | p99 < 10ms (GetItem), < 50ms (Query) |
| ConditionalCheckFailedRequests | 1 minute | Track optimistic locking contention |
| TransactionConflict | 1 minute | > 5% indicates design issues |

**Contributor Insights (Throttled Keys)**
```
Enable throttled-keys-only mode for cost-effective monitoring
Track partition keys causing throttling
Identify hot partitions
```

#### Dashboard Layout

**DynamoDB Fleet Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total Tables     │ Throttled (1h)   │ Avg Latency      │ Total Capacity   │
│ 142              │ 3 tables         │ 4.2ms            │ 24,000 RCU/WCU   │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Table Health**
| Table | Mode | RCU Used/Provisioned | WCU Used/Provisioned | Read Throttles | Write Throttles | Latency (p99) | Hot Partition Keys |
|-------|------|----------------------|----------------------|----------------|-----------------|---------------|--------------------|
| Orders | On-Demand | Auto | Auto | 0 | 0 | 3.8ms | None |
| Sessions | Provisioned | 1,240/2,000 | 890/1,000 | 0 | 42 | 8.2ms | session_2024-11-15 |

**GSI Health**
| Table | GSI Name | Status | WCU Used/Provisioned | Throttle Events | Backfill Progress |
|-------|----------|--------|----------------------|-----------------|-------------------|
| Orders | OrdersByDate | Active | 340/500 | 0 | 100% |
| Products | ProductsByCategory | Building | 0/500 | 0 | 67% |

**Throttling Analysis**
| Table | Throttle Type | Count (1h) | Root Cause | Recommendation |
|-------|---------------|------------|------------|----------------|
| Sessions | Partition Limit | 142 | Hot partition key | Improve key design |
| Analytics | Account Limit | 8 | Account max reached | Request limit increase |

---

## 4. NETWORKING DASHBOARDS

### 4.1 VPC Network Monitoring Dashboard

**Data Sources:** VPC Flow Logs, CloudWatch VPC Metrics, AWS Network Insights

#### Critical Operational Metrics

**Network Address Usage (NAU)**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| NetworkAddressUsage | Daily | > 80% of VPC CIDR |
| SubnetAvailableIPAddressCount | Hourly | < 20 IPs per subnet |

**Flow Log Analysis**
| Metric | Source | Alert Threshold |
|--------|--------|-----------------|
| Rejected Connections | Flow Logs | > 100/min (security group/NACL misconfiguration) |
| Top Talkers (Source IP) | Flow Logs | Anomaly detection |
| Top Talkers (Destination Port) | Flow Logs | Unexpected ports |
| Cross-AZ Traffic Volume | Flow Logs | Cost optimization opportunity |
| Internet Egress Traffic | Flow Logs | Cost tracking |

**ENI Status**
| Metric | Source | Alert Threshold |
|--------|--------|-----------------|
| ENI Attachment Status | EC2 API | Detached unexpectedly |
| ENI Network Interface Count | EC2 API | Approaching VPC limits |

#### Dashboard Layout

**VPC Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total VPCs       │ Available IPs    │ Flow Logs Enabled│ Rejected Conn/min│
│ 24               │ 12,847 / 65,536  │ 24/24 (100%)     │ 42               │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**VPC Health Table**
| VPC | CIDR | Subnets | Available IPs | NAU % | Rejected Conns | Cross-AZ Traffic (GB/day) | Internet Egress (GB/day) |
|-----|------|---------|---------------|-------|----------------|---------------------------|--------------------------|
| prod-vpc | 10.0.0.0/16 | 12 | 8,472 / 65,536 | 87% | 12 | 1,240 | 4,820 |

**Top Talkers Analysis**
| Source IP | Destination | Protocol | Port | Bytes (1h) | Status | Investigation |
|-----------|-------------|----------|------|------------|--------|---------------|
| 10.0.1.45 | 52.94.12.34 | TCP | 443 | 12 GB | Accepted | Normal API traffic |
| 10.0.2.18 | 18.234.45.67 | TCP | 3389 | 240 MB | Rejected | ⚠️ RDP attempt blocked |

---

### 4.2 Route53 Operational Dashboard

**Data Sources:** Route53 Resolver Metrics, Route53 Query Logging

#### Critical Operational Metrics

**Resolver Endpoint Health**
| Metric | Alert Threshold |
|--------|-----------------|
| EndpointHealthStatus | Any endpoint not OPERATIONAL |
| CapacityStatus | Warning (1) or Critical (2) |

**Query Metrics**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| InboundQueryVolume | 1 minute | Baseline deviation |
| OutboundQueryVolume | 1 minute | Baseline deviation |
| QueryLogDropped | 1 minute | > 0 |

---

### 4.3 ELB (ALB/NLB) Operational Dashboard

**Data Sources:** CloudWatch ELB Metrics, Access Logs

#### Critical Operational Metrics

**Load Balancer Health**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| HealthyHostCount | 1 minute | < minimum required for redundancy |
| UnHealthyHostCount | 1 minute | > 0 |
| TargetConnectionErrorCount | 1 minute | > 0 |
| TargetResponseTime | 1 minute | p99 > SLA threshold |

**Request Metrics**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| RequestCount | 1 minute | Baseline deviation |
| RejectedConnectionCount | 1 minute | > 0 (at capacity) |
| HTTPCode_Target_4XX_Count | 1 minute | > 1% of requests |
| HTTPCode_Target_5XX_Count | 1 minute | > 0.1% of requests |
| HTTPCode_ELB_5XX_Count | 1 minute | > 0 (LB issue) |

**Performance Metrics**
| Metric | Percentile | Alert Threshold |
|--------|------------|-----------------|
| TargetResponseTime | p50, p90, p99 | p99 > 1s |
| RequestCountPerTarget | Max | Uneven distribution |

#### Dashboard Layout

**Load Balancer Fleet**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total LBs        │ Healthy Targets  │ Requests (1h)    │ 5xx Error Rate   │
│ 34 (ALB+NLB)     │ 847 / 850        │ 42.8M            │ 0.002%           │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Load Balancer Health**
| LB Name | Type | Targets (Healthy/Total) | Requests/min | Latency (p99) | 4xx Rate | 5xx Rate | Rejected Conns |
|---------|------|-------------------------|--------------|---------------|----------|----------|----------------|
| api-alb | ALB | 12/12 | 14,200 | 245ms | 0.8% | 0.001% | 0 |
| legacy-nlb | NLB | 3/4 | 840 | 12ms | N/A | N/A | 0 |

---

### 4.4 CloudFront Operational Dashboard

**Data Sources:** CloudWatch CloudFront Metrics, CloudFront Access Logs, Real-Time Logs

#### Critical Operational Metrics

**Cache Performance**
| Metric | Update Frequency | Optimization Target |
|--------|------------------|---------------------|
| CacheHitRate | 1 minute | > 85% |
| OriginLatency | 1 minute | p95 < 500ms |
| OriginConnections | 1 minute | Track connection pooling |

**Request Metrics**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| Requests | 1 minute | Baseline deviation |
| BytesDownloaded | 1 minute | Track bandwidth |
| BytesUploaded | 1 minute | Track POST/PUT traffic |
| 4xxErrorRate | 1 minute | > 5% |
| 5xxErrorRate | 1 minute | > 1% |

**Geographic Distribution**
| Metric | Source | Business Value |
|--------|--------|----------------|
| Requests by Edge Location | CloudWatch | Traffic distribution |
| Latency by Geography | Real-Time Logs | User experience by region |
| Top Countries by Traffic | Access Logs | Content strategy |

#### Dashboard Layout

**CloudFront Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Distributions    │ Cache Hit Rate   │ Requests (1h)    │ Bandwidth (1h)   │
│ 18               │ 91.2%            │ 124M             │ 8.4 TB           │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**Distribution Health**
| Distribution | Cache Hit % | Requests/min | Origin Latency (p95) | 4xx Rate | 5xx Rate | Top Geo | Bandwidth (TB/day) |
|--------------|-------------|--------------|----------------------|----------|----------|---------|-------------------|
| cdn-prod | 94.2% | 42,000 | 124ms | 0.2% | 0.01% | US (45%) | 12.4 |
| cdn-video | 88.1% | 18,400 | 842ms | 1.2% | 0.08% | EU (38%) | 142.8 |

**Geographic Performance**
| Edge Location | Requests (1h) | Latency (p50) | Cache Hit % | Bandwidth |
|---------------|---------------|---------------|-------------|-----------|
| IAD (Virginia) | 24M | 12ms | 95% | 1.8 TB |
| LHR (London) | 18M | 18ms | 92% | 1.4 TB |

---

## 5. APPLICATION INTEGRATION DASHBOARDS

### 5.1 API Gateway Operational Dashboard

**Data Sources:** CloudWatch API Gateway Metrics, API Gateway Access Logs

#### Critical Operational Metrics

**Request Volume & Latency**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| Count (requests) | 1 minute | Baseline deviation |
| Latency | 1 minute | p99 > SLA threshold |
| IntegrationLatency | 1 minute | Identify backend bottlenecks |

**Error Rates**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| 4XXError | 1 minute | > 5% |
| 5XXError | 1 minute | > 1% |

**Integration Health**
| Metric | Update Frequency | Alert Threshold |
|--------|------------------|-----------------|
| CacheHitCount | 1 minute | Track cache effectiveness |
| CacheMissCount | 1 minute | Low hit rate indicates caching issues |

#### Dashboard Layout

**API Gateway Overview**
```
┌──────────────────┬──────────────────┬──────────────────┬──────────────────┐
│ Total APIs       │ Requests (1h)    │ Latency (p99)    │ Error Rate       │
│ 24               │ 8.4M             │ 142ms            │ 0.12%            │
└──────────────────┴──────────────────┴──────────────────┴──────────────────┘
```

**API Health Table**
| API Name | Stage | Requests/min | Latency (p50/p99) | Integration Latency (p99) | 4xx % | 5xx % | Cache Hit % |
|----------|-------|--------------|-------------------|---------------------------|-------|-------|-------------|
| user-api | prod | 4,200 | 45ms / 218ms | 198ms | 0.8% | 0.02% | 78% |
| payment-api | prod | 840 | 124ms / 842ms | 812ms | 2.1% | 0.18% | 12% |

---

## 6. RESOURCE LIFECYCLE MANAGEMENT

### 6.1 Resource Age & Staleness Tracking

**Dimensions to Track:**
- Resource creation date
- Last modification date
- Last access date (where available)
- Resource type
- Owner/team tag

**Age Categories:**
| Category | Definition | Action |
|----------|------------|--------|
| Recent | < 90 days | Monitor normally |
| Aging | 90-365 days | Review for continued need |
| Old | 1-2 years | Validate business justification |
| Very Old | 2+ years | Strong candidate for decommission |

**Staleness Indicators:**
| Resource Type | Staleness Metric | Threshold |
|---------------|------------------|-----------|
| EC2 Instance | No CloudWatch metric updates | 24 hours |
| EBS Volume | VolumeIdleTime = 100% | 7 days |
| S3 Object | Days since last access (Storage Lens) | 90 days |
| Lambda Function | No invocations | 30 days |
| RDS Instance | Zero connections | 7 days |
| Load Balancer | Zero requests | 7 days |

### 6.2 Orphaned Resource Detection

**Detection Rules:**

**Compute:**
- EBS volumes in "available" state (not attached) > 7 days
- Elastic IPs not associated with running instances
- Snapshots older than retention policy
- AMIs not used in last 90 days
- Launch templates with zero associated ASGs

**Networking:**
- Security groups with no attached resources
- NACLs with default rules only
- NAT Gateways with zero traffic
- VPN connections in "available" state with no traffic

**Storage:**
- S3 buckets with zero requests in 90 days
- EFS file systems with zero clients
- Glacier vaults with no retrieval activity

**Database:**
- RDS snapshots older than retention policy
- DynamoDB tables with zero requests in 30 days

### 6.3 Configuration Drift Detection

**AWS Config Rules:**
- Encryption enabled on required resources
- Backup policy compliance
- Tagging compliance
- Security group rule changes
- IAM policy changes

### 6.4 Resource Ownership & Accountability

**Tagging Strategy:**
```
Required Tags:
- Owner (email or team)
- CostCenter
- Environment (prod/staging/dev)
- Project
- ExpirationDate (for temporary resources)

Optional Tags:
- DataClassification
- Compliance (HIPAA, PCI, etc.)
- BackupPolicy
```

**Ownership Dashboard:**
| Owner | Resources | Untagged | Old Resources (2+ years) | Orphaned | Monthly Cost |
|-------|-----------|----------|--------------------------|----------|--------------|
| team-api@company.com | 142 | 8 (5.6%) | 12 (8.5%) | 3 | $12,400 |
| team-data@company.com | 87 | 24 (27.6%) | 34 (39.1%) | 18 | $8,200 |

---

## 7. CAPACITY PLANNING BY RESOURCE TYPE

### 7.1 Growth Trend Analysis

**Per-Service Metrics:**

**EC2:**
- Instance count trend (daily/weekly/monthly)
- vCPU utilization trend
- Instance family distribution over time
- Reserved vs. On-Demand vs. Spot mix

**RDS:**
- Total provisioned IOPS trend
- Storage growth rate (GB/day)
- Connection pool utilization trend
- Read replica count trend

**S3:**
- Storage growth rate (TB/month)
- Request volume growth (requests/day trend)
- Object count growth rate

**Lambda:**
- Concurrent execution trend
- Total invocation growth rate
- Duration × Memory (GB-second) trend

### 7.2 Saturation Metrics & Headroom

**EC2 Capacity:**
| Metric | Current | Limit | Headroom | Estimated Days to Limit |
|--------|---------|-------|----------|-------------------------|
| Running On-Demand Instances (m5) | 842 | 1,000 | 158 (15.8%) | 45 days at current growth |
| Total vCPUs | 3,400 | 5,000 | 1,600 (32%) | 120 days |
| Elastic IPs | 42 | 50 | 8 (16%) | 90 days |

**VPC Capacity:**
| VPC | CIDR | Used IPs | Available IPs | Headroom % | Est. Exhaustion |
|-----|------|----------|---------------|------------|-----------------|
| prod-vpc | 10.0.0.0/16 | 58,000 | 7,536 | 11.5% | 3 months |
| staging-vpc | 10.1.0.0/16 | 12,400 | 53,136 | 81% | 2+ years |

**DynamoDB Capacity:**
| Table | Mode | Current RCU/WCU | Max Observed (7d) | Peak Headroom | Throttle Risk |
|-------|------|-----------------|-------------------|---------------|---------------|
| Orders | Provisioned | 2,000 / 1,000 | 1,842 / 942 | 7.9% / 5.8% | High |
| Sessions | On-Demand | Auto | 8,400 / 4,200 | Auto-scaled | Low |

**Lambda Concurrency:**
| Function | Reserved Concurrency | Max Observed | Headroom | Throttle Events (7d) |
|----------|----------------------|--------------|----------|----------------------|
| api-handler | 500 | 487 | 2.6% | 0 |
| batch-processor | 200 | 124 | 38% | 0 |

### 7.3 Reserved Capacity vs On-Demand Utilization

**EC2 Reserved Instance Coverage:**
| Instance Family | Total Hours | RI Hours | On-Demand Hours | Spot Hours | RI Coverage % | Opportunity |
|-----------------|-------------|----------|-----------------|------------|---------------|-------------|
| m5 | 240,000 | 180,000 | 55,000 | 5,000 | 75% | Purchase 30 more m5.large RIs |
| r5 | 120,000 | 40,000 | 80,000 | 0 | 33% | High savings opportunity |

**RDS Reserved Instance Utilization:**
| DB Engine | RI Count | RI Utilization % | Unused RI Hours (30d) | Wasted Cost |
|-----------|----------|------------------|----------------------|-------------|
| PostgreSQL | 12 | 94.2% | 168 hours | $420 |
| MySQL | 8 | 68.4% | 912 hours | $1,840 |

### 7.4 Multi-Region Capacity Distribution

**Regional Resource Distribution:**
| Region | EC2 Instances | RDS DBs | S3 Buckets | Total Cost/Month | % of Total |
|--------|---------------|---------|------------|------------------|------------|
| us-east-1 | 842 | 42 | 124 | $184,200 | 45% |
| us-west-2 | 487 | 24 | 87 | $98,400 | 24% |
| eu-west-1 | 340 | 18 | 64 | $72,800 | 18% |
| ap-southeast-1 | 124 | 8 | 28 | $34,200 | 8% |

**Disaster Recovery Capacity:**
| Primary Region | DR Region | RTO | RPO | Standby Capacity % | DR Test Last Run |
|----------------|-----------|-----|-----|-------------------|------------------|
| us-east-1 | us-west-2 | 1 hour | 15 min | 50% (warm) | 14 days ago |
| eu-west-1 | eu-central-1 | 4 hours | 1 hour | 10% (cold) | 45 days ago |

---

## 8. SERVICE HEALTH & QUALITY METRICS

### 8.1 Service-Level Indicators (SLIs) per Resource Type

**CloudWatch Application Signals Integration:**
AWS now provides native SLI tracking through CloudWatch Application Signals with automatic service discovery.

**EC2-Based Services:**
| SLI | Metric | Target | Measurement Window |
|-----|--------|--------|-------------------|
| Availability | InstanceStatusCheckPassed | 99.9% | Monthly |
| Response Time | Application latency (custom metric) | p99 < 500ms | 5 minutes |
| Error Rate | Application errors / Total requests | < 0.1% | 5 minutes |

**Lambda Services:**
| SLI | Metric | Target | Measurement Window |
|-----|--------|--------|-------------------|
| Availability | (Invocations - Errors) / Invocations | 99.95% | Monthly |
| Latency | Duration (p99) | < 1s | 1 minute |
| Cold Start Impact | InitDuration events / Invocations | < 5% | Hourly |

**RDS Services:**
| SLI | Metric | Target | Measurement Window |
|-----|--------|--------|-------------------|
| Availability | Uptime | 99.95% | Monthly |
| Query Performance | Query latency (p95) | < 100ms | 1 minute |
| Replication Lag | ReplicaLag | < 5s | 1 minute |

**DynamoDB Services:**
| SLI | Metric | Target | Measurement Window |
|-----|--------|--------|-------------------|
| Availability | SuccessfulRequestLatency availability | 99.99% | Monthly |
| Latency | SuccessfulRequestLatency (p99) | < 10ms (GetItem) | 1 minute |
| Throttle Rate | ThrottledRequests / TotalRequests | < 0.01% | 1 minute |

**API Gateway Services:**
| SLI | Metric | Target | Measurement Window |
|-----|--------|--------|-------------------|
| Availability | (Count - 5XXError) / Count | 99.9% | Monthly |
| Latency | Latency (p99) | < 500ms | 1 minute |
| Error Budget | Remaining error budget | > 10% of monthly | Real-time |

### 8.2 Quality of Service Scoring

**Service Quality Score (0-100):**
```
Score = (
  (Availability SLI % × 0.40) +
  (Performance SLI % × 0.30) +
  (Error Rate SLI % × 0.20) +
  (Operational Health % × 0.10)
)
```

**Scoring Example:**
| Service | Availability | Performance | Error Rate | Ops Health | Quality Score | Grade |
|---------|--------------|-------------|------------|------------|---------------|-------|
| api-service | 99.98% | 99.2% | 99.95% | 95% | 98.8 | A+ |
| legacy-batch | 99.5% | 85% | 98% | 70% | 92.3 | A- |
| data-pipeline | 98% | 92% | 95% | 88% | 94.4 | A |

### 8.3 Integration Health Between Services

**Service Dependency Map:**
```
API Gateway → Lambda → DynamoDB
           ↘ RDS
           ↘ S3

CloudFront → S3
          ↘ API Gateway
```

**Dependency Health Matrix:**
| Source Service | Dependency | Call Volume | Latency (p99) | Error Rate | Health Status |
|----------------|------------|-------------|---------------|------------|---------------|
| API Gateway | Lambda (api-handler) | 4.2M/hour | 245ms | 0.02% | ✓ Healthy |
| API Gateway | RDS (prod-db-01) | 840K/hour | 124ms | 0.001% | ✓ Healthy |
| Lambda (processor) | DynamoDB (Orders) | 2.1M/hour | 8ms | 0% | ✓ Healthy |
| Lambda (etl) | S3 (data-lake) | 340K/hour | 1,840ms | 0.12% | ⚠️ Slow |

**Cross-Service Error Correlation:**
When errors spike in dependent services simultaneously, indicate root cause:
```
10:42 AM - API Gateway 5xx errors: 142/min
10:42 AM - Lambda api-handler errors: 138/min
10:42 AM - RDS prod-db-01: MaxConnections reached

→ Root Cause: Database connection pool exhaustion
```

### 8.4 Dependency Chain Visualization

**Critical Path Analysis:**
| Request Path | Latency Budget | Actual (p99) | Bottleneck | Optimization |
|--------------|----------------|--------------|------------|--------------|
| CloudFront → ALB → Lambda → DynamoDB | 500ms | 387ms | Lambda cold starts | Provisioned concurrency |
| API Gateway → Lambda → RDS | 800ms | 1,240ms | RDS query | Add index, cache |

---

## 9. IMPLEMENTATION ROADMAP

### Phase 1: Foundation (Months 1-3)
**Objective:** Establish core operational monitoring infrastructure

**Deliverables:**
1. Enable CloudWatch detailed monitoring across all critical resources
2. Deploy CloudWatch Agent on EC2/EKS/ECS for memory/disk metrics
3. Enable VPC Flow Logs and S3 Access Logs
4. Configure CloudWatch Container Insights for EKS/ECS
5. Enable RDS Performance Insights → migrate to Database Insights
6. Set up DynamoDB Contributor Insights (throttled-keys-only mode)
7. Create baseline dashboards for:
   - EC2 Fleet Health
   - Lambda Performance
   - RDS Database Health
   - DynamoDB Throttling
   - VPC Network Monitoring

**Success Metrics:**
- 100% critical resources monitored
- < 5-minute data freshness
- Baseline anomaly detection operational

### Phase 2: Lifecycle & Capacity (Months 4-6)
**Objective:** Implement resource lifecycle tracking and capacity planning

**Deliverables:**
1. Deploy AWS Config for orphaned resource detection
2. Implement resource age tracking (correlation with CUR data)
3. Build capacity planning dashboards with saturation metrics
4. Configure EC2 Capacity Manager
5. Create ownership accountability dashboards
6. Implement automated tagging compliance checks
7. Set up multi-region capacity distribution views

**Success Metrics:**
- 95% resource tagging compliance
- Identify and remediate 80% of orphaned resources
- 90-day capacity forecast accuracy > 90%

### Phase 3: SLIs & Quality (Months 7-9)
**Objective:** Establish service quality metrics and SLI tracking

**Deliverables:**
1. Enable CloudWatch Application Signals for automatic SLI collection
2. Define SLOs for all production services
3. Build service quality scorecards
4. Implement dependency health tracking
5. Create service catalog with health status
6. Configure automated alerting on SLO violations
7. Build executive service health dashboard

**Success Metrics:**
- SLIs defined for 100% of production services
- < 5-minute SLO violation detection
- Service quality scores visible to all teams

### Phase 4: Optimization & Automation (Months 10-12)
**Objective:** Automate operational insights and cost correlation

**Deliverables:**
1. Correlation dashboards (Operational Metrics + CUR Cost Data)
2. Right-sizing recommendations based on operational utilization
3. Automated lifecycle remediation workflows
4. Capacity planning with cost projections
5. Performance-based cost optimization recommendations
6. Multi-account aggregation and rollup views
7. API access for programmatic dashboard integration

**Success Metrics:**
- 80% of optimization recommendations automated
- 20% reduction in operational toil
- Seamless operational + financial visibility

---

## 10. DATA INTEGRATION ARCHITECTURE

### 10.1 Data Source Integration

**CloudWatch as Central Hub:**
```
┌─────────────────────────────────────────────────────────┐
│                    CloudWatch                            │
│  ┌────────────┬──────────────┬─────────────────────┐   │
│  │ Metrics    │ Logs Insights│ Application Signals │   │
│  └────────────┴──────────────┴─────────────────────┘   │
└─────────────────────────────────────────────────────────┘
           ▲              ▲              ▲
           │              │              │
    ┌──────┴──────┐  ┌───┴────┐  ┌──────┴────────┐
    │   EC2/ECS   │  │  VPC   │  │  API Gateway  │
    │   Lambda    │  │ Flow   │  │  ALB/NLB      │
    │   RDS       │  │ Logs   │  │  CloudFront   │
    │   DynamoDB  │  │ S3 Logs│  │               │
    └─────────────┘  └────────┘  └───────────────┘
```

**Cost Correlation via CUR:**
```
┌─────────────────────────────────────────────────────────┐
│         AWS CUR 2.0 (Athena/S3)                         │
│  Cost data with resource-level attribution              │
└─────────────────────────────────────────────────────────┘
           ▲
           │ Join on: line_item_resource_id
           │
┌──────────┴──────────────────────────────────────────────┐
│       Unified Dashboard (Looker / QuickSight)           │
│  Operational Metrics + Cost Attribution                 │
└─────────────────────────────────────────────────────────┘
```

### 10.2 Looker Integration Approach

**Recommended Architecture:**

**Option 1: Federated Dashboards**
- Operational Dashboards: CloudWatch Dashboards (real-time)
- Cost Dashboards: Looker (CUR-based)
- Integration: Cross-links between dashboards

**Option 2: Unified Looker Platform (Advanced)**
```
Looker ← BigQuery/Athena ← CloudWatch Metrics (export to S3)
      ← Athena ← CUR 2.0 Data (S3)
      
Join on: resource_id + timestamp
```

**Challenge:** CloudWatch metrics export to S3 has delay (near-real-time lost)
**Recommendation:** Use federated approach for real-time ops, unified for analysis

---

## 11. COST INTEGRATION EXAMPLES

### Example 1: EC2 Right-Sizing with Performance Context

**Dashboard View:**
| Instance | CPU Avg | Memory Avg | Current Type | Monthly Cost | Recommended Type | Est. Savings | Performance Impact |
|----------|---------|------------|--------------|--------------|------------------|--------------|-------------------|
| i-abc123 | 15% | 22% | m5.2xlarge | $280 | m5.large | $140/mo | None (over-provisioned) |
| i-def456 | 92% | 88% | t3.medium | $35 | m5.large | -$30/mo | Improved (consistent performance) |

### Example 2: Lambda Cold Start vs. Provisioned Concurrency Cost

**Analysis:**
| Function | Cold Start % | Avg Cold Start Latency | Current Cost | Provisioned Concurrency Cost | User Impact Score | Recommendation |
|----------|--------------|------------------------|--------------|------------------------------|-------------------|----------------|
| api-critical | 12% | 3,200ms | $120/mo | $420/mo | High (customer-facing) | Enable PC (worth extra $300) |
| batch-processor | 8% | 1,800ms | $840/mo | $2,100/mo | Low (internal) | Keep on-demand |

### Example 3: S3 Storage Class Optimization

**Dashboard:**
| Bucket | Size (TB) | Current Class | Avg Days Since Access | Recommended Class | Current Cost | Projected Cost | Savings |
|--------|-----------|---------------|----------------------|-------------------|--------------|----------------|---------|
| logs-2023 | 124 | Standard | 340 | Glacier Instant | $2,852/mo | $508/mo | $2,344/mo |
| analytics | 87 | Standard | 45 | Intelligent-Tiering | $1,998/mo | $1,198/mo | $800/mo |

---

## 12. KEY TAKEAWAYS & RECOMMENDATIONS

### 12.1 Critical Success Factors

1. **Real-Time Monitoring Required:** Operational dashboards need 1-minute or better data freshness
2. **Cost Context Essential:** Correlate performance metrics with cost data for holistic optimization
3. **Automated Anomaly Detection:** Manual review doesn't scale; implement ML-based anomaly detection
4. **Tag Governance Foundation:** Without proper tagging, ownership and accountability tracking fails
5. **SLI-Driven Culture:** Define and track SLIs for all production services
6. **Capacity Planning Discipline:** Track saturation metrics proactively; don't wait for outages
7. **Lifecycle Automation:** Automatically identify and remediate orphaned/stale resources

### 12.2 Recommended Dashboard Hierarchy

**Tier 1: Executive (10 dashboards)**
- Cross-Service Health Scorecard
- SLI/SLO Summary
- Capacity Headroom Overview
- Incident Response Dashboard
- Cost & Performance Correlation

**Tier 2: Engineering Teams (30+ dashboards)**
- Service-specific operational dashboards (EC2, Lambda, RDS, etc.)
- Dependency health dashboards
- Performance deep-dives
- Capacity planning per service

**Tier 3: Specialized (20+ dashboards)**
- Security & Compliance
- Lifecycle & Orphaned Resources
- Network Flow Analysis
- Database Query Performance

### 12.3 Technology Recommendations

**Data Collection:**
- CloudWatch Agent (EC2 memory/disk)
- CloudWatch Container Insights (EKS/ECS)
- CloudWatch Application Signals (SLIs)
- VPC Flow Logs
- S3 Storage Lens
- RDS Database Insights (replacing Performance Insights)

**Visualization:**
- CloudWatch Dashboards (real-time operational)
- Looker (cost analysis & correlation)
- Grafana (alternative for Prometheus integration)

**Automation:**
- AWS Config (compliance & orphaned resources)
- EventBridge (automated remediation)
- Lambda (custom metrics & enrichment)

### 12.4 Future-Proofing (2025-2035)

**Emerging Trends to Monitor:**
1. **Generative AI Workload Monitoring**
   - Bedrock token usage and cost
   - SageMaker inference endpoint performance
   - GPU utilization and efficiency

2. **Sustainability Metrics**
   - Carbon emissions per service
   - Renewable energy percentage by region
   - Efficiency scores (compute per carbon)

3. **Multi-Cloud Readiness**
   - Standardized metric naming across clouds
   - Cloud-agnostic SLI definitions
   - Unified capacity planning

4. **FinOps + Ops Convergence**
   - Real-time cost per transaction
   - Performance-adjusted cost metrics
   - Automated cost-performance optimization

---

## APPENDIX A: Metric Glossary

**Average Active Sessions (AAS):** Database load metric; number of concurrent sessions actively running queries

**DBLoad:** RDS/Aurora performance metric representing database activity level

**NAU (Network Address Usage):** VPC metric tracking IP address consumption

**P50/P90/P99:** Percentile latency metrics (50th, 90th, 99th percentile)

**RCU/WCU:** DynamoDB Read Capacity Units / Write Capacity Units

**SLI (Service Level Indicator):** Quantitative measure of service level (e.g., latency, error rate)

**SLO (Service Level Objective):** Target value for an SLI (e.g., p99 latency < 100ms)

**Saturation:** Metric approaching its maximum limit (capacity planning indicator)

**Throttling:** Rate limiting applied when capacity is exceeded

---

## APPENDIX B: AWS Service Metric References

**Official Documentation:**
- EC2 Metrics: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html
- Lambda Metrics: https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html
- RDS Metrics: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html
- DynamoDB Metrics: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/metrics-dimensions.html
- Container Insights: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
- Application Signals: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-ServiceLevelObjectives.html

---

**Document Metadata:**
- **Author:** AWS Resource Operational Dashboard Research Team
- **Created:** 2025-11-17
- **Version:** 1.0
- **Next Review:** 2026-05-17 (6 months)
- **Scope:** 10-year outlook (2025-2035)

