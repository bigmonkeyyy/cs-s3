locals {
  asg_names = [
    "Momo-Test-ASG1",
    "Momo-Test-ASG2",
  ]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "test"

  dashboard_body = <<EOF
{
  "widgets": [
    {
        "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            [ 
                "AWS/ApplicationELB", 
                "ProcessedBytes", "LoadBalancer", "${aws_lb.frontend-lb.arn_suffix}",
                { "label": "Frontend ELB Processed Bytes", "color": "#17becf" }
            ],
            [ 
                "...", "${aws_lb.backend-lb.arn_suffix}", 
                { "label": "Backend ELB Processed Bytes" } 
            ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "title": "ELB Traffic Metrics",
        "stat": "Average",
        "period": 60,
        "legend": {
            "position": "bottom"
        }
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 3,
      "height": 3,
      "properties": {
        "metrics": [
            [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${aws_lb.frontend-lb.arn_suffix}", { "label": "Frontend ELB Processed Bytes", "color": "#17becf", "visible": false } ],
            [ "...", "${aws_lb.backend-lb.arn_suffix}", { "label": "Backend ELB Processed Bytes", "visible": false } ],
            [ ".", "TargetResponseTime", ".", ".", { "label": "Response Time BE", "color": "#d62728" } ],
            [ "...", "${aws_lb.frontend-lb.arn_suffix}", { "label": "Response Time FE", "color": "#2ca02c" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "title": "BE/FE Response times",
        "stat": "Average",
        "period": 60,
        "legend": {
            "position": "bottom"
        },
        "yAxis": {
            "right": {
                "label": ""
            },
            "left": {
                "showUnits": true,
                "min": 0
            }
        }
      }
    }
  ]
}
EOF
}