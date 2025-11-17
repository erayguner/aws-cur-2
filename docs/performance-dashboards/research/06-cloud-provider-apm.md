# Cloud Provider APM Features (AWS, Azure, GCP) - 2025-2035

## Executive Summary
Major cloud providers offer native APM and observability services that integrate deeply with their platforms. This research compares AWS, Azure, and GCP observability capabilities, integration patterns, and future roadmaps.

## 1. AWS Observability Stack

### 1.1 Amazon CloudWatch

**Core Capabilities:**
- **Metrics:** Pre-defined and custom metrics collection
  - EC2, Lambda, RDS, ECS, EKS metrics automatically collected
  - Custom metrics via API (up to 1-second granularity)
  - Metric math for derived metrics
  - Anomaly detection with ML

- **Logs:** Centralized log aggregation and analysis
  - CloudWatch Logs Insights for querying (similar to SQL)
  - Log groups and streams organization
  - Real-time log streaming
  - Retention policies (1 day to forever)

- **Alarms:** Threshold and anomaly-based alerting
  - Static thresholds
  - Anomaly detection (ML-based)
  - Composite alarms (combine multiple alarms)
  - Actions: SNS, Auto Scaling, Lambda, Systems Manager

- **Dashboards:** Visual monitoring
  - Line, stacked area, number, gauge widgets
  - Markdown widgets for annotations
  - Cross-region, cross-account dashboards
  - Auto-refresh (10s, 1m, 5m intervals)

**Cost:**
- Metrics: $0.30 per metric per month
- Custom metrics: $0.30 per metric (high-resolution: $0.10 per metric)
- API requests: $0.01 per 1,000 requests
- Logs: $0.50 per GB ingested, $0.03 per GB archived
- Alarms: $0.10 per alarm per month

**Limitations:**
- 15-month metric retention (limited historical analysis)
- Query performance degrades with large log volumes
- No built-in distributed tracing (need X-Ray)

### 1.2 AWS X-Ray (Distributed Tracing)

**Capabilities:**
- **Distributed Tracing:** End-to-end request flow visualization
  - Automatic instrumentation for Lambda, API Gateway, ECS
  - SDKs for Java, .NET, Node.js, Python, Ruby, Go
  - Trace sampling (reduce cost while maintaining visibility)
  
- **Service Map:** Visual dependency graph
  - Automatic service discovery
  - Latency and error rate by service
  - Health indicators (green, yellow, red)

- **Trace Analysis:**
  - Filter by response time, error status, annotations
  - Group traces by similar patterns
  - Identify bottlenecks and errors

- **Integrations:**
  - Lambda (native integration)
  - API Gateway (enable with configuration)
  - ECS/EKS (via X-Ray daemon sidecar)
  - Elastic Beanstalk (automatic)

**Cost:**
- Recording: $5.00 per 1 million traces recorded
- Retrieval: $0.50 per 1 million traces retrieved
- Scanning: $0.50 per 1 million traces scanned

**Limitations:**
- 30-day trace retention
- Limited query capabilities compared to commercial APM
- No automatic root cause analysis

### 1.3 CloudWatch RUM (Real User Monitoring)

**Capabilities (Launched 2021):**
- **Frontend Performance:**
  - Core Web Vitals (LCP, FID/INP, CLS)
  - Page load times
  - JavaScript errors
  - Network performance

- **User Session Tracking:**
  - Session replay (coming soon)
  - User journey tracking
  - Geographic distribution

- **Integration:**
  - JavaScript snippet injection
  - Works with any web app (React, Vue, Angular, vanilla)

**Cost:**
- $1.00 per 100,000 events

### 1.4 CloudWatch Application Insights

**Capabilities:**
- **Automated Problem Detection:**
  - ML-powered anomaly detection
  - Correlates logs, metrics, traces
  - Root cause suggestions

- **Application Topology:**
  - Auto-discovered application components
  - Dependency mapping
  - Health status visualization

- **Supported Applications:**
  - .NET applications on EC2/ECS
  - Java applications
  - SQL Server, IIS, custom applications

**Cost:**
- Included with CloudWatch (no additional charge)

### 1.5 AWS Distro for OpenTelemetry (ADOT)

**Capabilities:**
- AWS-supported OpenTelemetry distribution
- Send traces/metrics to X-Ray, CloudWatch, Prometheus, Datadog, etc.
- Vendor-neutral instrumentation
- Future-proof observability strategy

**Integrations:**
- EKS (recommended for Kubernetes APM)
- ECS (Fargate and EC2)
- Lambda (via layers)
- EC2 (via ADOT Collector)

### 1.6 Amazon Managed Service for Prometheus (AMP)

**Capabilities:**
- Fully managed Prometheus-compatible monitoring
- Scales automatically (no capacity planning)
- HA across multiple AZs
- Long-term metric storage (150 days default)
- Query with PromQL

**Use Cases:**
- Kubernetes monitoring (containers, pods, nodes)
- Microservices metrics
- Custom application metrics

**Cost:**
- Metric samples ingested: $0.90 per 10M samples
- Query samples processed: $0.10 per 10M samples
- Storage: $0.03 per GB-month

### 1.7 Amazon Managed Grafana (AMG)

**Capabilities:**
- Fully managed Grafana for visualization
- Pre-built dashboards for AWS services
- Data source integrations:
  - CloudWatch, X-Ray, AMP, Athena, Redshift
  - Third-party: Datadog, New Relic, Splunk

**Cost:**
- Editor license: $9 per editor per month
- Viewer: No charge (unlimited viewers)

## 2. Azure Observability Stack

### 2.1 Azure Monitor

**Core Capabilities:**
- **Unified Platform:** Metrics, logs, traces in one service
- **Automatic Data Collection:**
  - Platform metrics (VM, App Service, AKS)
  - Guest OS metrics (with agent)
  - Application metrics (via Application Insights)

- **Log Analytics Workspace:**
  - KQL (Kusto Query Language) for powerful queries
  - Cross-resource queries
  - Workbooks for visualization

- **Metrics Explorer:**
  - Interactive metric charting
  - Multi-dimensional metrics
  - Metric splitting and filtering

**Cost:**
- Logs: First 5 GB per billing account per month free, then $2.99 per GB
- Metrics: First 10M data points ingested per month free, then $0.26 per million
- Retention: 31 days included, up to 730 days available ($0.12 per GB per month)

### 2.2 Azure Application Insights

**Capabilities:**
- **APM for Web Applications:**
  - Automatic instrumentation (.NET, Java, Node.js, Python)
  - Request tracking and performance
  - Dependency tracking (databases, HTTP calls, queues)
  - Exception tracking with stack traces

- **Distributed Tracing:**
  - End-to-end transaction tracking
  - Application Map (visual service dependencies)
  - Performance investigation tools

- **User Analytics:**
  - User, session, page view tracking
  - User flows and funnels
  - Retention cohort analysis

- **Smart Detection:**
  - AI-powered anomaly detection
  - Failure anomalies (unusual error patterns)
  - Performance anomalies (latency spikes)
  - Memory leak detection

- **Profiler:**
  - Production profiling for .NET applications
  - CPU and memory profiling
  - Minimal overhead (<5%)

**Integration:**
- Native integration with .NET, Java, Node.js
- OpenTelemetry support
- Azure App Service (one-click enable)
- Azure Functions (auto-instrumentation)
- AKS (via DAPR or manual instrumentation)

**Cost:**
- First 5 GB per month free
- $2.99 per GB ingested
- Multi-step web tests: $7.50 per test per month

### 2.3 Azure Monitor for Containers

**Capabilities (AKS Monitoring):**
- **Container Insights:**
  - Node and pod performance metrics
  - Container logs aggregation
  - Cluster health and capacity
  - Live container logs and kubectl proxy

- **Prometheus Integration:**
  - Scrape Prometheus metrics
  - Store in Log Analytics
  - Query with KQL

**Cost:**
- Included in Azure Monitor pricing
- Logs charged per GB ingested

### 2.4 Azure Service Health

**Capabilities:**
- **Azure Status:** Global Azure service health
- **Service Issues:** Personalized incident notifications
- **Planned Maintenance:** Advance notice
- **Health Advisories:** Security and reliability recommendations

**Integration:**
- Alerts via email, SMS, webhook
- Service Health dashboard

### 2.5 Azure Workbooks

**Capabilities:**
- **Interactive Reports:**
  - Combine text, KQL queries, metrics, parameters
  - Template gallery (100+ pre-built workbooks)
  - Custom visualizations

- **Use Cases:**
  - Performance analysis
  - Failure analysis
  - Usage and capacity planning
  - Custom business dashboards

**Cost:**
- No additional charge (included with Azure Monitor)

## 3. Google Cloud Observability Stack

### 3.1 Cloud Monitoring (formerly Stackdriver)

**Capabilities:**
- **Metrics Collection:**
  - Automatic for GCE, GKE, Cloud Run, App Engine, Cloud Functions
  - Custom metrics via API
  - 6-week retention (standard metrics), up to 24 months (custom)

- **Dashboards:**
  - Pre-configured dashboards for GCP services
  - Custom dashboards with MQL (Monitoring Query Language) or PromQL
  - Charting: Line, area, bar, heatmap, table

- **Alerting:**
  - Metric-based alerts
  - Log-based alerts
  - Uptime checks (synthetic monitoring)
  - Notification channels: Email, PagerDuty, Slack, webhooks

**Cost:**
- Monitoring API calls: First 1M calls per month free, then $0.01 per 1,000 calls
- Chargeable metrics: First 150 MiB per billing account per month free, then:
  - 150-100,000 MiB: $0.2580 per MiB
  - 100,000-250,000 MiB: $0.1510 per MiB
  - >250,000 MiB: $0.0610 per MiB

### 3.2 Cloud Trace (Distributed Tracing)

**Capabilities:**
- **Distributed Tracing:**
  - Automatic for App Engine, Cloud Run, GKE (with config)
  - SDKs for Java, .NET, Node.js, Python, Ruby, Go, PHP
  - OpenTelemetry support (recommended)

- **Trace Analysis:**
  - Latency analysis by percentile
  - Scatter plots (find outliers)
  - Trace comparison
  - Filter by latency, time range, labels

- **Performance Insights:**
  - RPC latency breakdown
  - Application-level latency attribution
  - Daily trace density reports

**Cost:**
- First 2.5 million trace spans per month free
- $0.20 per million trace spans ingested thereafter

**Retention:**
- 30 days

### 3.3 Cloud Logging (formerly Stackdriver Logging)

**Capabilities:**
- **Centralized Logging:**
  - Automatic for all GCP services
  - Agent for GCE, GKE
  - Structured logging (JSON)
  - Log sinks to BigQuery, Cloud Storage, Pub/Sub

- **Logs Explorer:**
  - Query with Logging Query Language (similar to SQL)
  - Real-time log tailing
  - Histogram view (log volume over time)
  - Saved queries and filters

- **Log-Based Metrics:**
  - Convert logs to metrics
  - Alert on log patterns (e.g., error rate)

**Cost:**
- First 50 GiB per project per month free
- $0.50 per GiB thereafter
- Retention: 30 days default (no charge), extended retention up to 3650 days ($0.01 per GiB per month)

### 3.4 Cloud Profiler

**Capabilities:**
- **Continuous Production Profiling:**
  - CPU profiling (flame graphs)
  - Heap profiling (memory usage)
  - Low overhead (<0.5% CPU, <100 KB RAM)
  - Supported: Java, Go, Python, Node.js, .NET

- **Analysis:**
  - Compare profiles over time
  - Identify performance regressions
  - Optimize hot code paths

**Cost:**
- No additional charge (included with GCP)

**Unique Feature:**
- One of the few free, production-grade continuous profilers

### 3.5 Cloud Debugger

**Capabilities:**
- **Live Debugging:**
  - Set breakpoints in production code (no restarts)
  - Inspect variables without stopping execution
  - Logpoints (inject log statements without redeployment)

- **Supported:**
  - Java, Python, Go, Node.js, .NET
  - App Engine, GKE, GCE, Cloud Run

**Cost:**
- No additional charge

### 3.6 Error Reporting

**Capabilities:**
- **Automatic Error Aggregation:**
  - Group similar errors
  - Stack trace deduplication
  - Error trends and frequency
  - Alerts on new or frequent errors

- **Integration:**
  - Automatic for App Engine, Cloud Functions
  - Manual for GCE, GKE (via logging)

**Cost:**
- No additional charge (included with Cloud Logging)

## 4. Multi-Cloud Comparison

### 4.1 Feature Matrix

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| **Metrics Monitoring** | CloudWatch | Azure Monitor | Cloud Monitoring |
| **Distributed Tracing** | X-Ray | App Insights | Cloud Trace |
| **Log Aggregation** | CloudWatch Logs | Log Analytics | Cloud Logging |
| **APM** | X-Ray + CW | App Insights | Cloud Trace + Monitoring |
| **Real User Monitoring** | CloudWatch RUM | App Insights | (Third-party) |
| **Profiling** | (Third-party) | App Insights Profiler | Cloud Profiler ⭐ |
| **Debugger** | (Third-party) | Snapshot Debugger | Cloud Debugger ⭐ |
| **Synthetic Monitoring** | CloudWatch Synthetics | App Insights | Cloud Monitoring Uptime |
| **OpenTelemetry** | ADOT ⭐ | Supported | Supported ⭐ |
| **Prometheus** | AMP ⭐ | Azure Monitor | Cloud Monitoring (PromQL) |
| **Grafana** | AMG ⭐ | Grafana integration | Partner Grafana |
| **ML Anomaly Detection** | CloudWatch | App Insights Smart Detection | (Basic) |
| **Cost** | Medium | High | Low-Medium |

**Legend:**
- ⭐ = Strong offering or unique advantage

### 4.2 Best Use Cases by Cloud

**AWS:**
- Best for: Lambda-heavy serverless architectures, multi-account organizations
- Strengths: X-Ray Lambda integration, CloudWatch service breadth, ADOT
- Weaknesses: Higher cost at scale, fragmented tools

**Azure:**
- Best for: .NET applications, enterprise with Active Directory integration
- Strengths: Application Insights comprehensiveness, unified platform, KQL power
- Weaknesses: Highest cost, learning curve for KQL

**GCP:**
- Best for: Kubernetes (GKE), cost-conscious organizations, open-source preference
- Strengths: Free profiler, Cloud Debugger, low cost, OpenTelemetry-first
- Weaknesses: Less mature APM than Azure App Insights, smaller ecosystem

### 4.3 Cost Comparison (Example: Medium SaaS App)

**Assumptions:**
- 100 EC2/VM instances
- 10 TB logs per month
- 1 million traces per day
- 10 custom dashboards

**Monthly Costs:**

| Service | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Metrics | $1,500 | $1,200 | $900 |
| Logs | $5,000 | $29,900 | $4,750 |
| Traces | $4,650 | $29,900 (logs) | $1,800 |
| Dashboards | $0 | $0 | $0 |
| **Total** | **$11,150** | **$31,100** | **$7,450** |

**Note:** Azure is most expensive due to high log ingestion costs.

## 5. Integration with Cost Data (CUR, Azure Cost, GCP Billing)

### 5.1 AWS Cost and Usage Report (CUR) Integration

**Architecture:**
```
AWS Services → CloudWatch Metrics → Athena (CUR data)
              → X-Ray Traces     → Join on tags/time
              → Performance metrics correlated with cost
```

**Join Strategy:**
```sql
-- Join CloudWatch metrics with CUR data
SELECT
  cw.service_name,
  cw.avg_latency_ms,
  cw.request_count,
  cur.line_item_unblended_cost,
  cur.line_item_unblended_cost / cw.request_count AS cost_per_request
FROM cloudwatch_metrics cw
JOIN cur_data cur
  ON cw.resource_id = cur.resource_id
  AND DATE_TRUNC('hour', cw.timestamp) = DATE_TRUNC('hour', cur.usage_start_date)
WHERE cw.timestamp >= CURRENT_DATE - INTERVAL '7' DAY
GROUP BY 1, 2, 3, 4
ORDER BY cost_per_request DESC;
```

**Tagging Strategy:**
- Tag all resources with: `Service`, `Environment`, `Team`, `CostCenter`
- Enable in both CloudWatch and CUR
- Use tags as join key for cost-performance correlation

### 5.2 Azure Cost Management Integration

**Architecture:**
```
Azure Resources → Azure Monitor Metrics → Azure Cost Management API
                → App Insights Traces  → Join on tags/subscription
                → Unified cost-performance view
```

**Query with KQL:**
```kql
// Join performance metrics with cost data
let costs = AzureCostManagement
| where TimeGenerated >= ago(7d)
| summarize TotalCost = sum(CostInBillingCurrency) by bin(TimeGenerated, 1h), ResourceId;

let performance = AzureMetrics
| where TimeGenerated >= ago(7d)
| where MetricName == "ResponseTime"
| summarize AvgLatency = avg(Average), RequestCount = sum(Count) by bin(TimeGenerated, 1h), ResourceId;

costs
| join kind=inner performance on TimeGenerated, ResourceId
| extend CostPerRequest = TotalCost / RequestCount
| project TimeGenerated, ResourceId, AvgLatency, RequestCount, TotalCost, CostPerRequest
| order by CostPerRequest desc
```

### 5.3 GCP Billing Export to BigQuery

**Architecture:**
```
GCP Resources → Cloud Monitoring Metrics → BigQuery (Billing Export)
              → Cloud Trace             → BigQuery (Trace Export via sink)
              → Join in BigQuery        → Looker dashboards
```

**BigQuery Join:**
```sql
-- Join performance and cost data
WITH performance AS (
  SELECT
    TIMESTAMP_TRUNC(timestamp, HOUR) AS hour,
    resource.labels.service_name AS service,
    AVG(metric.latency) AS avg_latency_ms,
    COUNT(*) AS request_count
  FROM `project.monitoring.metrics`
  WHERE metric.type = 'serviceruntime.googleapis.com/api/request_latencies'
    AND timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  GROUP BY 1, 2
),
costs AS (
  SELECT
    TIMESTAMP_TRUNC(usage_start_time, HOUR) AS hour,
    service.description AS service,
    SUM(cost) AS total_cost
  FROM `project.billing_export.gcp_billing_export_v1_XXXXXX`
  WHERE usage_start_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  GROUP BY 1, 2
)
SELECT
  p.hour,
  p.service,
  p.avg_latency_ms,
  p.request_count,
  c.total_cost,
  c.total_cost / p.request_count AS cost_per_request,
  (p.request_count / p.avg_latency_ms) / c.total_cost AS efficiency_score
FROM performance p
JOIN costs c ON p.hour = c.hour AND p.service = c.service
ORDER BY efficiency_score ASC;
```

## 6. Hybrid and Multi-Cloud Observability

### 6.1 OpenTelemetry for Vendor Neutrality

**Unified Instrumentation:**
```javascript
// Single instrumentation, multiple backends
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-otlp-grpc');

const provider = new NodeTracerProvider();

// Export to multiple backends simultaneously
provider.addSpanProcessor(new BatchSpanProcessor(
  new OTLPTraceExporter({ url: 'http://aws-xray-collector:4317' })  // AWS X-Ray
));
provider.addSpanProcessor(new BatchSpanProcessor(
  new OTLPTraceExporter({ url: 'http://azure-monitor:4317' })  // Azure Monitor
));
provider.addSpanProcessor(new BatchSpanProcessor(
  new OTLPTraceExporter({ url: 'http://datadog-agent:4317' })  // Datadog
));

provider.register();
```

**Benefits:**
- Single instrumentation effort
- Switch backends without code changes
- Multi-cloud data aggregation
- Future-proof architecture

### 6.2 Centralized Observability Platform

**Architecture:**
```
AWS Services     → OTEL Collector →
Azure Services   → OTEL Collector → Centralized Backend (Datadog, New Relic, Elastic)
GCP Services     → OTEL Collector →
On-Prem Services → OTEL Collector →
```

**Centralized Backend Options:**
- **Datadog:** Best multi-cloud support, highest cost
- **New Relic:** Good APM, moderate cost
- **Elastic:** Open-source, self-hosted, low cost
- **Splunk:** Enterprise-grade, high cost
- **Grafana Cloud:** Cost-effective, growing features

### 6.3 Multi-Cloud Cost-Performance Dashboard

**Unified View:**
- Aggregate metrics from AWS CloudWatch + Azure Monitor + GCP Monitoring
- Combine cost data from all three billing systems
- Normalize metrics (different units, naming conventions)
- Single pane of glass for multi-cloud observability

**Challenges:**
- Different metric formats and semantics
- Time zone and timestamp normalization
- Tag/label standardization
- Real-time data synchronization

**Solutions:**
- OpenTelemetry Collector for normalization
- BigQuery or Snowflake as centralized data warehouse
- Looker for unified dashboards across clouds

## 7. Future Cloud APM Trends (2025-2035)

### 7.1 AI-Native Observability (2025-2027)

**AWS:**
- CloudWatch AI: Autonomous anomaly detection and remediation
- X-Ray intelligent path analysis
- Cost-performance auto-optimization

**Azure:**
- Application Insights AIOps: Full automation
- Azure Copilot for observability (natural language queries)

**GCP:**
- Vertex AI integration with Cloud Monitoring
- Predictive SLO violation alerts
- Automatic capacity planning

### 7.2 Edge and IoT Observability (2027-2030)

**Requirements:**
- Monitor billions of edge devices
- Low-latency telemetry collection
- Federated trace aggregation
- Edge-to-cloud correlation

**Cloud Provider Support:**
- AWS IoT Core + CloudWatch integration
- Azure IoT Hub + Azure Monitor
- GCP IoT Core + Cloud Monitoring

### 7.3 Quantum Computing Observability (2030-2035)

**New Metrics:**
- Qubit coherence time
- Gate fidelity
- Quantum circuit depth
- Entanglement quality

**Providers:**
- AWS Braket observability
- Azure Quantum monitoring
- GCP Quantum Engine telemetry

### 7.4 Sustainability Metrics Integration

**Carbon-Aware Monitoring:**
- CO2 emissions per request
- Energy consumption tracking
- Green region routing effectiveness
- Carbon budget alerts

**Cloud Provider Commitments:**
- AWS: Carbon-neutral by 2040
- Azure: Carbon-negative by 2030
- GCP: Carbon-free by 2030

**Dashboard Integration:**
- Performance + Cost + Carbon unified view
- Optimize for environmental impact
- Sustainability SLOs

## 8. Recommendations for Looker Dashboards

### 8.1 Multi-Cloud Performance Dashboard

**Data Sources:**
- AWS CloudWatch → Athena → Looker
- Azure Monitor → Synapse Analytics → Looker
- GCP Monitoring → BigQuery → Looker

**Unified Metrics:**
- Latency (P50, P95, P99) across all clouds
- Throughput (requests per second)
- Error rate (4xx, 5xx)
- Cost per request (normalized across clouds)

### 8.2 Cloud Provider Comparison Dashboard

**Visualizations:**
- Cost comparison by service type
- Performance comparison (same workload, different clouds)
- Reliability comparison (uptime, SLA adherence)
- Optimization recommendations (right cloud for workload)

### 8.3 OpenTelemetry-Based Dashboards

**Advantage:**
- Cloud-agnostic metrics
- Consistent data model
- Easy to add new clouds or backends

**Implementation:**
- OTEL Collector → BigQuery/Snowflake
- Looker connects to centralized data warehouse
- Semantic layer maps OTEL metrics to business KPIs

## 9. Implementation Roadmap

### Phase 1 (2025): Consolidation
- Standardize on OpenTelemetry across all clouds
- Implement centralized data warehouse (BigQuery/Snowflake)
- Build foundational Looker dashboards

### Phase 2 (2026-2027): Integration
- Cost-performance correlation dashboards
- Multi-cloud optimization recommendations
- AI-powered anomaly detection

### Phase 3 (2028-2030): Automation
- Self-optimizing multi-cloud infrastructure
- Autonomous workload placement
- Predictive capacity planning

### Phase 4 (2031-2035): Intelligence
- AGI-powered observability assistants
- Quantum computing optimization
- Carbon-neutral performance optimization

## Conclusion

Cloud provider APM tools are evolving from basic monitoring to AI-powered, autonomous optimization platforms. Key takeaways:

1. **AWS:** Broadest service coverage, good for serverless
2. **Azure:** Best APM (App Insights), highest cost
3. **GCP:** Most cost-effective, open-source friendly

For multi-cloud:
- Use **OpenTelemetry** for vendor neutrality
- Centralize data in **BigQuery** or **Snowflake**
- Build unified dashboards in **Looker**
- Optimize workload placement by cloud strengths

The future is multi-cloud, AI-driven, and sustainability-focused.
