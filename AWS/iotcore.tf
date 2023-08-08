resource "aws_iot_thing" "cloud-migration-mqtt-server" {
  name = "ibeacon-mqtt-server"

  attributes = {
    First = "examplevalue"
  }
}

resource "aws_iot_policy" "ibeacon-pubsub" {
  name = "Publish-Subscribe"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iot_endpoint" "example" {

}


resource "aws_iot_certificate" "iot-core-certificate" {
  active = true
}