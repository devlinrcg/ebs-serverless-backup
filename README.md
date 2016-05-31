# EBS Snapshot Backup for Amazon EC2 instances
> Before you continue this, read the footnote on EBS Snapshots

###### How it works
* Each directory in this repository represents **ONE** AWS Region. This means that templates can be launched in **ANY** AWS Region with AWS Lambda available;
    * As an example: if you have your Amazon EC2 instances on the SaoPaulo Region, you will have to launch the stack, let's say, on Virginia's Region (which will have the AWS Lambda availability), using the directory/template from SaoPaulo;
* Every time you edit a script, you must execute the zip_all.sh on that directory;
* The AWS Cloudformation template creates, automatically, a role and policy for your AWS Lambda Functions;  

###### Usage
* Go to [Amazon S3](https://console.aws.amazon.com/s3/);
* Create a Bucket and click on it;
* Upload the files **ebs-backup-lambda.zip** and **ebs-backup-lambda.template** from the directory representing the AWS Region where you want to execute the Functions;
* Click on the **ebs-backup-lambda.template**, and then on **Properties**;
* Copy the link presented to you, e.g.: https://s3.amazonaws.com/YOUR_BUCKET/ec2-startstop.template
* Now, go to [AWS Cloudformation](https://console.aws.amazon.com/cloudformation/);
* click on **Create Stack**;
    * In **Specify an Amazon S3 template URL**,  insert the link for your template (copied before), and click next;
    * Put the information needed: in **S3BucketName**, put the name of your Bucket, created earlier;
    * In **SNSTopicName**, insert a name for an AWS Push Notification Service topic to be created, which will be used to alert you in case of any error/alert on the Function execution;
    * Next, Next, Create;
    * When launched, resources will be created automatically;
    * After everything is created, go to the Management Console for AWS Push Notification Service and subscribe to the created topic, so you can receive alerts;
* Repeat these steps for different AWS Regions;
* To schedule these Functions to be executed at a time/date/rate of your choice, after launching the Stacks, insert an **Event Source** in each AWS Lambda Function, as informed below:
    * Go to [AWS Lambda](https://console.aws.amazon.com/lambda);
    * Click on the Function you want to schedule an event;
    * Click on the **Event sources** tab;
    * Click on **Add event source**;
    * On this screen:
      * Event source type: **Cloudwatch Events - Schedule**;
      * Rule name: a name for your rule;
      * Rule description: a description for your rule;
      * Schedule expression: follow the expressions below;
      * **Submit** and done;
      * Repeat these steps for each Function;

###### Expressions - Schedule an Event
Same as cron (Linux), following the UTC (+3BRT) timezone. Some examples:

* Executed at 17:00 (BRT) from monday until friday:
```
      cron(0 20 ? * MON-FRI * )
```
* Executed at 8:00 (BRT) from monday until friday:
```
      cron(0 11 ? * MON-FRI * )
```  

##### For EBS to be backed up as a Snapshot:
* In each Amazon EC2 instance that you need the Snapshot Backup, insert the Tag **Backup** or **backup**; don't need any Value on these Tags;
* In each Amazon EC2 instance that you need a retention, insert the Tag **Retention** or **retention**, with Value in **DAYS** (e.g.: for a 7 days retention, put 7 on the Tag Value);  

**TAGS ARE CASE-SENSITIVE!!!**

###### File
```
ebs-serverless-backup
├── California
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Frankfurt
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Ireland
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Oregon
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── README.md
├── SaoPaulo
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Seoul
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Singapore
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Sydney
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Tokyo
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
└── Virginia
    ├── ebs-backup-lambda.template
    ├── ebs-backup-lambda.zip
    ├── ebs_snapshot_function.py
    ├── janitor_function.py
    └── zip_all.sh
```
> Note on EBS Snapshots: for high/intensive I/O (Write/Read) volumes, its recommended the STOP/Freeze this I/O (or the STOP for this Amazon EC2 instance) before executing the EBS Snapshot. This script **WILL NOT** STOP/Freeze your instance.
