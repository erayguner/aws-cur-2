# Resource-Type Operational Dashboards - Quick Reference Guide

**For:** Engineering, DevOps, SRE, and Platform Teams  
**Purpose:** Quick lookup for operational metrics beyond cost  

---

## Quick Metric Lookup by AWS Service

### EC2 - Essential Operational Metrics

**Basic (CloudWatch Default - Free)**
- `CPUUtilization` - Alert: > 80% sustained or < 20% underutilized
- `StatusCheckFailed` - Alert: > 0
- `NetworkIn/Out` - Alert: Approaching instance limit
- `DiskReadOps/WriteOps` - Alert: Baseline deviation

**Advanced (CloudWatch Agent Required)**
- `mem_used_percent` - Alert: > 85%
- `disk_used_percent` - Alert: > 80%
- `swap_used_percent` - Alert: > 50% (memory pressure)

**Key Actions:**
- Right-sizing: CPU < 20% or > 80% consistently
- Memory upgrade: mem% > 85% or swap used
- Orphaned detection: VolumeIdleTime = 100% for 7+ days

### Lambda - Essential Operational Metrics

**Performance**
- `Duration` (p99) - Alert: > timeout - 1s
- `InitDuration` - Cold starts; target: < 3s (p90)
- `Errors` - Alert: > 1% error rate
- `Throttles` - Alert: > 0

**Concurrency**
- `ConcurrentExecutions` - Alert: > 80% of limit
- `ProvisionedConcurrencySpilloverInvocations` - Alert: > 0

**Key Actions:**
- Enable Provisioned Concurrency: Cold start % > 10% AND customer-facing
- Right-size memory: Duration increases with memory decrease
- Add timeout buffer: p99 duration approaching timeout

### RDS - Essential Operational Metrics

**⚠️ Transition Alert:** Performance Insights EOL June 30, 2026 → Use Database Insights

**Critical Metrics**
- `DBLoad` (AAS) - Alert: > vCPU count
- `CPUUtilization` - Alert: > 80%
- `FreeableMemory` - Alert: < 10%
- `FreeStorageSpace` - Alert: < 20%
- `DatabaseConnections` - Alert: > 80% of max_connections
- `ReplicaLag` - Alert: > 30 seconds

**Key Actions:**
- Scale vertically: CPU > 80% or Memory < 10%
- Scale storage: FreeStorageSpace < 20%
- Index optimization: DBLoadCPU high with slow queries
- Connection pooling: Connections > 80% of limit

### DynamoDB - Essential Operational Metrics

**🆕 2025 Update:** 8 new throttling metrics available

**Critical Metrics**
- `UserErrors` (Throttling) - Alert: > 0
- `ReadThrottleEvents` - Alert: > 0
- `WriteThrottleEvents` - Alert: > 0
- `SuccessfulRequestLatency` (p99) - Target: < 10ms (GetItem)
- `ConsumedReadCapacityUnits` - Alert: > 80% of provisioned

**Key Actions:**
- Enable On-Demand: Throttling events > 0 consistently
- Increase provisioned capacity: Utilization > 80%
- Fix partition key design: Hot partition throttling
- Enable Contributor Insights (throttled-keys-only): Track hot keys

### S3 - Essential Operational Metrics

**Storage Analytics**
- `BucketSizeBytes` - Daily tracking
- `NumberOfObjects` - Daily tracking
- `AllRequests` - Baseline deviation detection

**Access Patterns**
- Days Since Last Access (Storage Lens) - Target: < 90 for Standard
- `GetRequests` vs `PutRequests` - Read/write ratio

**Key Actions:**
- Enable Intelligent-Tiering: Unknown/changing access patterns
- Lifecycle to Glacier: Avg access > 90 days
- Delete incomplete multipart uploads: > 100 detected
- Clean up old versions: Non-current versions > 90 days

### EKS/ECS - Essential Operational Metrics

**Cluster Health**
- `ClusterFailedNodeCount` - Alert: > 0
- `pod_number_of_container_restarts` - Alert: > 3 in 5 min
- `container_cpu_utilization` - Alert: > 80%
- `container_memory_utilization` - Alert: > 85%

**Efficiency**
- Pod Density = Pods/Node - Maximize within limits
- CPU Request Utilization = Actual/Requested - Target: 70-90%
- Node Utilization = Used/Total - Target: > 65%

**Key Actions:**
- Right-size pods: CPU/Memory utilization consistently low
- Scale nodes: Node utilization > 80%
- Fix restart loops: Container restarts > 3 in 5 min
- Optimize resource requests: Actual utilization << requested

### API Gateway - Essential Operational Metrics

**Performance**
- `Count` - Request volume
- `Latency` (p99) - Alert: > SLA threshold
- `IntegrationLatency` (p99) - Backend bottleneck indicator
- `4XXError` - Alert: > 5%
- `5XXError` - Alert: > 1%

**Caching**
- `CacheHitCount` vs `CacheMissCount` - Cache effectiveness

**Key Actions:**
- Enable caching: Low cache hit rate and repeated queries
- Optimize backend: IntegrationLatency >> Latency delta
- Fix client errors: 4xx > 5% (API design issue)

### CloudFront - Essential Operational Metrics

**Cache Performance**
- `CacheHitRate` - Target: > 85%
- `OriginLatency` (p95) - Target: < 500ms
- `4xxErrorRate` - Alert: > 5%
- `5xxErrorRate` - Alert: > 1%

**Key Actions:**
- Optimize caching: Cache hit rate < 85%
- Origin optimization: OriginLatency high
- Geographic analysis: Identify underperforming edge locations

---

## Orphaned Resource Detection Checklist

- [ ] EBS volumes in "available" state > 7 days
- [ ] Elastic IPs not associated with running instances
- [ ] Snapshots older than retention policy
- [ ] AMIs not used in 90+ days
- [ ] Security groups with no attached resources
- [ ] S3 buckets with zero requests in 90+ days
- [ ] RDS snapshots beyond retention
- [ ] DynamoDB tables with zero requests in 30+ days
- [ ] Load Balancers with zero requests in 7+ days
- [ ] NAT Gateways with zero traffic

---

## Resource Staleness Thresholds

| Resource Type | Staleness Indicator | Threshold | Action |
|---------------|---------------------|-----------|--------|
| EC2 | No metric updates | 24 hours | Investigate |
| EBS Volume | VolumeIdleTime = 100% | 7 days | Detach/delete |
| S3 Object | Days since last access | 90 days | Lifecycle to cheaper tier |
| Lambda | No invocations | 30 days | Consider deprecation |
| RDS | Zero connections | 7 days | Investigate/downsize |
| Load Balancer | Zero requests | 7 days | Remove |

---

## Capacity Planning - Critical Saturation Metrics

**EC2:**
- Headroom Alert: < 20% of instance limit remaining
- Estimated Days to Limit: < 30 days at current growth

**VPC:**
- IP Headroom Alert: < 20% of CIDR available
- Subnet Exhaustion: < 20 IPs per subnet

**DynamoDB:**
- Capacity Headroom: < 20% of provisioned RCU/WCU
- On-Demand: Monitor for account-level throttling

**Lambda:**
- Concurrency Headroom: < 20% of reserved concurrency
- Account Limit: Track unreserved concurrent executions

**RDS:**
- Storage Headroom: < 20% free storage
- Connection Headroom: < 20% of max_connections available

---

## SLI Templates by Service Type

### Web API (API Gateway + Lambda)
- **Availability SLI:** (Total Requests - 5xx Errors) / Total Requests
- **Latency SLI:** p99 Latency
- **Error Budget:** 99.9% availability = 43.8 min downtime/month

### Database Service (RDS)
- **Availability SLI:** Uptime percentage
- **Performance SLI:** Query latency p95
- **Replication SLI:** Replica lag < 5s

### Storage Service (S3)
- **Availability SLI:** Successful requests / Total requests
- **Durability SLI:** 99.999999999% (eleven 9s)
- **Performance SLI:** Time to first byte p90

---

## Cost Correlation Quick Wins

**High CPU + Low Cost = Right-sizing Opportunity**
- EC2 instance running at 15% CPU
- Action: Downsize to smaller instance type
- Expected Savings: 30-50% for that instance

**High Cold Starts + Customer Impact = Provisioned Concurrency Worth It**
- Lambda with 15% cold starts, 3s cold start time, customer-facing
- Action: Enable Provisioned Concurrency despite higher cost
- Expected Impact: Better UX justifies higher spend

**Low Access + High Storage Cost = Lifecycle Opportunity**
- S3 Standard storage with 180+ day avg access
- Action: Intelligent-Tiering or Glacier transition
- Expected Savings: 40-90% depending on access pattern

**Orphaned Resources = Pure Waste**
- Unused EBS volumes, unattached Elastic IPs, idle Load Balancers
- Action: Immediate remediation
- Expected Savings: 100% of orphaned resource cost

---

## Dashboard Refresh Frequencies

| Dashboard Type | Update Frequency | Retention |
|----------------|------------------|-----------|
| EC2 Health | 1 minute | 14 days |
| Lambda Performance | 1 minute | 14 days |
| RDS Database Load | 1 second (Database Insights) | 7 days free, up to 2 years paid |
| DynamoDB Metrics | 1 minute | 14 days |
| VPC Flow Logs | 10 minutes (aggregation) | 7-30 days |
| S3 Storage Lens | Daily | 14 days free, 15 months (paid) |
| CloudFront | 1 minute | 14 days |
| Cost Data (CUR) | Hourly/Daily | Unlimited (S3) |

---

## Alerting Priority Matrix

| Severity | Condition | Response Time | Example |
|----------|-----------|---------------|---------|
| P1 - Critical | Service unavailable or severe degradation | < 15 min | RDS DBLoad > 2× vCPU, 5xx errors > 10% |
| P2 - High | Performance degradation affecting users | < 1 hour | Lambda throttling, API latency p99 > 2s |
| P3 - Medium | Capacity warning or non-critical errors | < 4 hours | VPC IP headroom < 20%, EC2 instance limit approaching |
| P4 - Low | Optimization opportunities | Next business day | Underutilized instances, orphaned resources |

---

## Recommended Tools by Category

**Real-Time Monitoring:**
- CloudWatch Dashboards (native, real-time)
- Grafana + Prometheus (alternative for Kubernetes)

**Cost Analysis:**
- Looker (CUR-based, this project)
- AWS Cost Explorer (native, limited)

**Unified Observability:**
- CloudWatch Application Signals (SLIs/SLOs)
- Datadog, New Relic (commercial, comprehensive)

**Lifecycle Management:**
- AWS Config (compliance, orphaned resources)
- AWS Systems Manager (inventory, automation)

**Capacity Planning:**
- Amazon EC2 Capacity Manager (2025 release, free)
- CloudWatch Metrics + Custom Dashboards

---

## Next Steps

1. **Audit Current Monitoring Coverage**
   - [ ] CloudWatch detailed monitoring enabled?
   - [ ] CloudWatch Agent deployed for memory/disk?
   - [ ] Container Insights enabled for EKS/ECS?
   - [ ] VPC Flow Logs enabled?
   - [ ] Database Insights configured?

2. **Establish Baselines**
   - [ ] Collect 30 days of operational metrics
   - [ ] Identify normal patterns and deviations
   - [ ] Set initial alerting thresholds

3. **Implement Quick Wins**
   - [ ] Identify and remediate orphaned resources
   - [ ] Enable Intelligent-Tiering for S3 buckets
   - [ ] Right-size obviously over/under-provisioned EC2

4. **Build Core Dashboards**
   - [ ] EC2 Fleet Health
   - [ ] Lambda Performance & Cold Starts
   - [ ] RDS Database Health
   - [ ] DynamoDB Throttling Monitor
   - [ ] Capacity Planning (Saturation)

5. **Correlate with Cost**
   - [ ] Join operational metrics with CUR data
   - [ ] Build performance-cost optimization views
   - [ ] Automate right-sizing recommendations

---

**Quick Reference Version:** 1.0  
**Last Updated:** 2025-11-17  
**Full Document:** See `RESOURCE_TYPE_OPERATIONAL_DASHBOARDS_DESIGN.md`
