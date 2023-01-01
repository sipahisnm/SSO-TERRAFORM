### Setup IAM Identity Center (SSO) ###
Creating SSO user with
[SSO userguide](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)

### Create two sub-accounts in AWS Organizations ###
[Creating sub account in AWS Organizasion](https://docs.aws.amazon.com/organizations/latest/userguide/
orgs_manage_accounts_create.html)

### Grant your user Administrator access to those two accounts ###
[In AWS Organization console assing Adeministration role to the sub accounts ](https://docs.aws.amazon.com
organizations/latest/userguide/orgs_manage_accounts_access.html)

### Setup AWS profiles locally to allow her to access both accounts using AWS SSO ###
1- Run the aws configure sso command and provide your IAM Identity Center start URL and the AWS Region tha
Identity Center directory.
```
$ aws configure sso
SSO session name (Recommended): my-sso
SSO start URL [None]: https://my-sso-portal.awsapps.com/start
SSO region [None]: us-east-1
SSO registration scopes [None]: sso:account:access
```
2- The AWS CLI displays the AWS accounts available for you to use. If you are authorized to use only one a
AWS CLI selects that account for you automatically and skips the prompt. The AWS accounts that are availab
to use are determined by your user configuration in IAM Identity Center.
```
There are 2 AWS accounts available to you.
> DeveloperAccount, developer-account-admin@example.com (123456789011) 
  ProductionAccount, production-account-admin@example.com (123456789022)
  ```
3- The AWS CLI confirms your account choice, and displays the IAM roles that are available to you in the s
account. If the selected account lists only one role, the AWS CLI selects that role for you automatically 
the prompt. The roles that are available for you to use are determined by your user configuration in IAM I
Center.
```
Using the account ID 123456789011
There are 2 roles available to you.
> ReadOnly
  FullAccess
```
4- Specify the default output format, the default AWS Region to send commands to, and providing a name for
so you can reference this profile from among all those defined on the local computer. In the following exa
user enters a default Region, default output format, and the name of the profile. You can alternatively pr
to select any default values that are shown between the square brackets. The suggested profile name is the
number followed by an underscore followed by the role name.
```
CLI default client Region [None]: us-west-2<ENTER>
CLI default output format [None]: json<ENTER>
CLI profile name [123456789011_ReadOnly]: my-dev-profile<ENTER>
```
5- A final message describes the completed profile configuration.
```
To use this profile, specify the profile name using --profile, as shown:

aws s3 ls --profile my-dev-profile
```
6- This results in creating the sso-session section and named profile in ~/.aws/config that looks like the
```
[profile my-dev-profile]
sso_session = my-sso
sso_account_id = 123456789011
sso_role_name = readOnly
region = us-west-2
output = json

[sso-session my-sso]
sso_region = us-east-1
sso_start_url = https://my-sso-portal.awsapps.com/start
sso_registration_scopes = sso:account:access
```
7- If you are signed in to the sso-session you are updating, refresh your token by running the aws sso log
```
aws sso login
```
If the AWS CLI can't open your browser, it prompts you to open it yourself and enter the specified code.
```
$ aws sso login --profile my-dev-profile
```
You can also specify which sso-session profile to use when logging in using the --sso-session parameter of
login command.
```
$ aws sso login --sso-session my-dev-session
```
You can login sso session and can take credential fromvthe account and paste the credential in .aws creden
can use that credential in terraform.
### Running a command with your IAM Identity Center enabled profile ###
```
aws sts get-caller-identity --profile my-dev-profile
```
### Signing out of your IAM Identity Center sessions ###
```
aws sso logout
```
In the terminal you can create tf file and you can use credentials from the account.

### Create a small terraform project that creates an S3 bucket named $account_id-sinem-bucket ###

Check-out tf files (main.tf, variables.tf,terraform.tfvars)

### Apply the Terraform project on two different accounts, using tfvars files ###

Check-out custom.tfvars . When you want to use it, use this comment:
```
terraform apply -var-file="custom.tfvars"
```



