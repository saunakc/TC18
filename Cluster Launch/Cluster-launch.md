# Pre-requisite

**An active AWS account**: If you do not have an AWS account you can [create and activate AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/). Note that you will need to provide credit card information for activating an AWS account.  Check with your instructor for any promo code that you can apply as credit.


# Redshift Cluster Launch and Connect to it via SQL Workbench/ J

## Create the IAM role you will need to copy S3 objects to Redshift
* Log on to the AWS console using your student account. Choose the AWS region assigned by your instructor.
* Choose the IAM service
* In the left navigation pane, choose **Roles**. 
* Choose **Create role**
* In the **AWS Service** pane, choose **Redshift** and from bottom of the screen select **Redshift - Customizable**. 
* Under Select your use case, choose Redshift - Customizable then choose **Next: Permissions**. 
* On the **Attach permissions policies** page, check the box next to **AmazonS3ReadOnlyAccess** and then choose **Next: Review**. 
* For **Role name**, type a name for your role. For this lab, use myRedshiftRole, then choose **Create Role**. 
* Once the role is created, click on *myRedshiftRole*
* Note the **Role ARN**—this is the Amazon Resource Name (ARN) for the role that you just created. You will need this later.


## Create a Redshift cluster
* From the AWS Console, choose the Amazon Redshift service.
* Change the region to US East (Ohio)
* Choose **Launch Cluster**
* On the Cluster Details page, enter the following values and then choose **Continue**: 
* **Cluster Identifier**: type democluster. 
* **Database Name**: type demodb. 
* **Database Port**: type 8192
* **Master User Name**: type rsadmin. You will use this username and password to connect to your database after the cluster is available. 
* **Master User Password and Confirm Password**: type a password for the master user account. Be sure to follow the rules for passwords. Don’t forget your password (!), and choose **Continue**
* Create a 4 node cluster using dc1.large 	and choose **Continue**
  * Node type : dc1.large
  * Cluster type : Multi Node
  * Number of compute nodes : 4 (type in)
* On the Additional Configuration page, use the default VPC and the default Security Group. Leave other settings on their defaults.
* For **AvailableRoles**, choose *myRedshiftRole* and then choose **Continue**. 
* On the Review page, double-check your choices and choose **Launch Cluster**. Choose **Close** to return to the Clusters dashboard.

## Authorize your access to the Redshift cluster, by adding a rule to your Security Group
* On the Clusters dashboard, click on democluster.
* Scroll down to find your VPC security groups. Click on your active security group.
* On the Security Group pane, click on **Inbound**
* Choose **Edit**, then **Add Rule**
* Assign a **Type** of **TCP/IP**, and enter the port range to 8192.
* Assign a **Source** of **Custom** and set the CIDR block to 0.0.0.0/0. Choose **Save**. [Note: this allows access to your Redshift cluster from any computer on the Internet. Never do this in a production environment!!!]

## Download and install SQL Workbench/J
* You will need Java 8 or higher running on your computer. Please check if you have Java installed. If you need Java, download and install from http://www.java.com/en/ 
* Download the current [Redshift JDBC Driver](https://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC42-1.2.10.1009.jar). 
* Download [SQL Workbench/J]( http://www.sql-workbench.net/downloads.html) and install it in your machine. Be sure to click on Manage Drivers (in the lower left corner of the configuration screen) and choose Amazon Redshift and the JDBC Driver you downloaded earlier.
* At the end of the installation it will be ready to connect to a database – stop when you get this step, as you have not yet configured a database to use!


## Connect to your Redshift cluster using SQL Workbench/J
* From the AWS Console, choose the Amazon Redshift service, then choose **Clusters** and click on democluster
* Scroll down to the JDBC URL. This is your connection string. Copy it. It should look something like:  _jdbc:redshift://democluster.cdkituczqepk.us-west-2.redshift.amazonaws.com:8192/demodb_
* Open SQL Workbench/J. Choose **File**, and then choose **Connect window**. Choose **Create a new connection profile**. 
* In the **New profile** text box, type a name for the profile. 
* In the **Driver box**, choose Amazon Redshift __(If the Redshift driver is red, then download and update the driver from, https://docs.aws.amazon.com/redshift/latest/mgmt/configure-jdbc-connection.html#download-jdbc-driver)__
* In the **URL box**, paste the connection string you copied earlier.
* In the **Username box**, type rsadmin
* In the **Password box**, type the password you chose when you created the Redshift cluster
* IMPORTANT: be sure to click to **Autocommit box**
* Choose **Test**. If there are any error messages, do what you need to fix them. If the test succeeds, choose **OK**.
