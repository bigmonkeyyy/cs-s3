resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.client}"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 4,
      "y": 1,
      "width": 14,
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
      "x": 4,
      "y": 0,
      "width": 14,
      "height": 6,
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
    },
    {
      "type": "metric",
      "x": 4,
      "y": 3,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_lb.frontend-lb.arn_suffix}", { "label": "Website requests", "color": "#2ca02c" } ],
            [ ".", "ActiveConnectionCount", ".", ".", { "label": "Active Connections", "color": "#98df8a" } ],
            [ ".", "TargetResponseTime", ".", ".", { "label": "Server response time", "visible": false } ],
            [ ".", "HTTPCode_Target_2XX_Count", ".", ".", { "visible": false } ],
            [ ".", "HTTPCode_Target_4XX_Count", ".", ".", { "label": "Server 4xx Errors", "color": "#d62728" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "title": "Frontend ELB Requests",
        "stat": "Average",
        "period": 60,
        "legend": {
            "position": "bottom"
        },
        "yAxis": {
            "left": {
                "min": 0
            }
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 3,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_lb.backend-lb.arn_suffix}", { "color": "#2ca02c", "label": "Request Count" } ],
          [ ".", "ActiveConnectionCount", ".", ".", { "color": "#98df8a", "label": "Active Connection Count" } ],
          [ ".", "HTTPCode_ELB_4XX_Count", ".", ".", { "color": "#d62728", "label": "Server 4xx Errors" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "title": "Backend ELB Requests",
        "stat": "Average",
        "period": 60,
        "legend": {
            "position": "bottom"
        }
      }
    },
    {
      "type": "metric",
      "x": 4,
      "y": 4,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", "frontend-asg-${var.client}", { "color": "#ffbb78", "label": "Desired Capacity" } ],
          [ "AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", "${aws_lb_target_group.frontend-tg.arn_suffix}", "LoadBalancer", "${aws_lb.frontend-lb.arn_suffix}" ],
          [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "frontend-asg-${var.client}", { "label": "In Service", "color": "#2ca02c" } ],
          [ ".", "GroupMaxSize", ".", ".", { "color": "#d62728", "label": "Max Size" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "title": "Frontend Instances",
        "region": "${var.aws_region}",
        "period": 60,
        "stat": "Average",
        "setPeriodToTimeRange": true,
        "yAxis": {
            "left": {
                "min": 0,
                "max": 10,
                "label": "Instance Count",
                "showUnits": false
            }
        },
        "liveData": true,
        "legend": {
            "position": "bottom"
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 4,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", "backend-asg-${var.client}", { "color": "#ffbb78", "label": "Desired Instances" } ],
          [ "AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", "${aws_lb_target_group.backend-tg.arn_suffix}", "LoadBalancer", "${aws_lb.backend-lb.arn_suffix}", { "color": "#ff7f0e" } ],
          [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "backend-asg-${var.client}", { "color": "#2ca02c", "yAxis": "left", "label": "In Service" } ],
          [ ".", "GroupMaxSize", ".", ".", { "color": "#d62728", "label": "Max Instances" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "title": "Backend Instances",
        "region": "${var.aws_region}",
        "period": 60,
        "stat": "Average",
        "setPeriodToTimeRange": true,
        "yAxis": {
            "left": {
                "min": 0,
                "max": 10,
                "label": "Instance Count",
                "showUnits": false
            }
        },
        "liveData": true,
        "legend": {
            "position": "bottom"
        }
      }
    },
    {
      "type": "metric",
      "x": 4,
      "y": 5,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "frontend-asg-${var.client}", { "color": "#2ca02c" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "legend": {
            "position": "hidden"
        },
        "yAxis": {
            "left": {
                "min": 0,
                "max": 100
            }
        },
        "liveData": true,
        "title": "Frontend CPU Load",
        "period": 5,
        "stat": "Average"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 5,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "backend-asg-${var.client}", { "color": "#2ca02c" } ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${var.aws_region}",
        "legend": {
            "position": "hidden"
        },
        "yAxis": {
            "left": {
                "min": 0,
                "max": 100
            }
        },
        "liveData": true,
        "title": "Backend CPU Load",
        "period": 5,
        "stat": "Average"
      }
    }
  ]
}
EOF
}