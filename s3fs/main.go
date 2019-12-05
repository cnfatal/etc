package main

import (
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	endpoint := "oss-cn-north-1.unicloudsrv.com"
	region := "oss-cn-north-1"
	// len 16 access key
	accessKey := "<16 chars access key>"
	// len 32 secret key
	secretKey := "<32 chars secret key>"
	bucketName := "aidptest"
	var conf = &aws.Config{
		Credentials: credentials.NewStaticCredentials(accessKey, secretKey, ""),
		// An optional endpoint URL (hostname only or fully qualified URI)
		// that overrides the default generated endpoint for a client. Set this
		// to `""` to use the default generated endpoint.
		//
		// Note: You must still provide a `Region` value when specifying an
		// endpoint for a client.
		Endpoint: aws.String(endpoint),
		Region:   aws.String(region),
		// Set this to `true` to force the request to use path-style addressing,
		// i.e., `http://s3.amazonaws.com/BUCKET/KEY`. By default, the S3 client
		// will use virtual hosted bucket addressing when possible
		// (`http://BUCKET.s3.amazonaws.com/KEY`).
		//
		// Note: This configuration option is specific to the Amazon S3 service.
		//
		// See http://docs.aws.amazon.com/AmazonS3/latest/dev/VirtualHosting.html
		// for Amazon S3: Virtual Hosting of Buckets
		S3ForcePathStyle: aws.Bool(true),
	}
	newSession, e := session.NewSession(conf)
	if e != nil {
		log.Fatal(e.Error())
	}
	// generate a s3 client
	var cli = s3.New(newSession)

	buckets, e := cli.ListBuckets(&s3.ListBucketsInput{})
	if e != nil {
		log.Fatal(e.Error())
	}
	for _, v := range buckets.Buckets {
		fmt.Print(v.String())
	}

	objects, e := cli.ListObjects(&s3.ListObjectsInput{
		Bucket: &bucketName,
	})
	if e != nil {
		log.Fatal(e.Error())
	}

	for _, v := range objects.Contents {
		fmt.Println(v.String())
	}
}
