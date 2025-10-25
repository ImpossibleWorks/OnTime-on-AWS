# OnTime on AWS

These instructions will guide you through setting up an [OnTime Server](#https://getontime.no/) on an EC2 instance in AWS. Please note that the server will be publicly accessible and lacks security measures. Proceed with caution.

I typically go through this process for each event I do. Once the event is over, I terminate everything as to not incur any costs between shows.

**\*Please note**: We are not associated with the OnTime team in any way, although we offer suggestions on the development from time to time.\*

## Getting Started

### Prerequisites

This repository assumes you have a simple understanding on the EC2 service on AWS, including:

- Understanding of [OnTime](#https://getontime.no/) and how it works.
- EC2 Instance creation and pricing impacts
- [Security Group](#security-group) creation and it's impact/implications
- A Key pair. There are a [number of guides](https://www.google.com/search?q=create+key+pair+for+ec2+instance) on the Internet.

#### Security Group

You'll need to create a Security Group. This is a virtual firewall that controls inbound and outbound traffic to and from your OnTime server instance, based on defined rules.

Log into your AWS console and visit the EC2 section. Select _Security Groups_ under the Network & Security Section in thethen _Create security group_ and set the minimum settings shown below.

#### Name and tags

```
Name: OnTime Security Group, or something memorable.
```

&nbsp;&nbsp;**Inbound rules**

| Type       | Port | Source                    | Description                          |
| ---------- | ---- | ------------------------- | ------------------------------------ |
| http       | 80   | Anywhere-IPv4 (0.0.0.0/0) | Used to see the timer in a browser   |
| Custom UDP | 8888 | Anywhere-IPv4 (0.0.0.0/0) | OSC input into the app               |
| Custom UDP | 9999 | Anywhere-IPv4 (0.0.0.0/0) | OSC output from the app              |
| SSH        | 22   | Anywhere-IPv4 (0.0.0.0/0) | Allows you to SSH into your instance |

&nbsp;&nbsp;**Inbound rules** - Leave as default

| Type        | Port | Source                    | Description          |
| ----------- | ---- | ------------------------- | -------------------- |
| All traffic | All  | Anywhere-IPv4 (0.0.0.0/0) | All outbound traffic |

## Deploying

Here is a step by step walk-through that will get an OnTime server up and running on an EC2 instance.

_Reminder that Amazon will charge you for all active instances, EBS volumes, etc. so don't forget to terminate things when you're done._

### Configure New Instance

Within the EC2 section of AWS, click the orange _Launch instance_ button then set these settings:

#### Name and tags

```
Name: OnTime, or anything you wish.
```

#### Application and OS Images - Amazon Machine Image (AM))

```
AMI: Amazon Linux 2023 AMI, 64-bit (x86)
```

#### Instance type

```
Instance type: t3.micro
```

<small>_Note: I've had success with type: t3.micro (which is free-tier eligible by the way), but if you need more power, up it to t2.medium, t3.medium, or higher._</small>

#### Key pair (login)

```
Key pair name: Your existing key pair
```

<small>_Note: I recommend using an existing key pair that you have the private key for. It just keeps things tidy. See [Prerequisites](#prerequisites)._</small>

#### Network settings

```
Select existing security group: OnTime Security Group.
```

<small>_Note: Choose whatever Security Group you created as part of the [Prerequisites](#prerequisites)._</small>

#### Configure storage

Leave the default settings. 8GiB gp3 is more than fine.

#### Advanced details

The meat and potatoes of this section is at _User data_ found by scrolling all the way to the bottom.

Simply copy the contents of the [User data content](#) into that field. Here's what it does:

- Installs and runs Docker
- Installs and runs the [OnTime container](https://hub.docker.com/r/getontime/ontime) from Docker Hub.
- Creates a **docker-compose.yml** file with a bunch of settings Docker needs to run the containerized version of OnTime. A few things to consider/change:
  - **80:4001/tcp**: This configures the public-facing port to 80, allowing you to access the URL without specifying a port number; you can change it to another port if desired, but you’ll need to include the port number in the URL.
  - **TZ=America/New_York**: Set this to the [desired timezone](https://www.w3schools.com/PHP/php_ref_timezones.asp).

Here are some other interesting/optional configurations within the _Advanced details_ section. You can generally leave all these settings to default, but here are some of my recommendations. These are based on the idea around that when I stop the instance, I want it to completely disappear...to save on running costs.

```
Shutdown behavior: Terminate
Stop protection: Disable
```

### Run Instance

After you configure everything above, hit that orange _Launch Instance_ button on the right. You should see the following message:

```
Success
Successfully initiated launch of instance (i-1234567890)
```

Now, head over to your EC2 dashboard, copy the public IP address of your instance and paste it into a new browser tab. Be sure to use http and not https.

If you changed the Port to something unique within your Security Group, you might have to add it after the IP address. Something like http://1.2.3.4:8080 or whatever port you chose.

#### Optional

To add that bit of polish, I tend to use [No-IP](https://no-ip.com) and give it a friendlier name like "timer.example.com". See their website (or any DDNS service for that matter) for details on assigning an IP to a domain name.

## Authors

- [**TC Conway**](https://github.com/tcconway)

## Contributing

Please contact the author.

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md) Creative Commons License.

Ultimately you are responsible for your actions. We take no claim to any result, even if you follow these instructions perfectly. All fees from Amazon (and all others) are also your responsibility.

## Acknowledgments

- Hat tip to the developers working on OnTime. It's a great app and is by far the best event timing app out there.
