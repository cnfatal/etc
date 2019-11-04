package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	var conf = &aws.Config{
		Credentials:      credentials.NewStaticCredentials("123", "password", "token"),
		Endpoint:         aws.String("http://192.168.2.18:4567"),
		Region:           aws.String("us-west-2"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(true),
	}
	name := "bucket"
	var cli = s3.New(session.New(conf))
	_, e := cli.CreateBucket(&s3.CreateBucketInput{Bucket: &name})
	if e != nil {
		println(e.Error())
	}
}
