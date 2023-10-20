## REGISTER A DOMAIN NAME
There are loads of domain providers, cloud services provides domain names as AWS has `route53` service to provision that. There are other providers which ofcourse aren't cloud providers such as `godaddy`, `namecheap`...

Create a domain of your choice with your preferred name. 

Assign an Elastic IP to your Nginx LB server and associate your domain name with this Elastic IP

You might have noticed, that every time you restart or stop/start your EC2 instance – you get a new public IP address. When you want to associate your domain name – it is better to have a static IP address that does not change after reboot. Elastic IP is 
the solution for this problem.

NB. You get charged only for an EIP when it's not in use.

Create an [A record](https://support.dnsimple.com/articles/a-record/) to point to the public-ip-address of the `nginx-lb-server`.

Configure Nginx to recognize your new domain name. Update your nginx.conf with server_name www.<your-domain-name.com> instead of server_name www.domain.com

## CREATE HOSTED ZONE IN ROUTE53
Return to your AWS console, navigate to `route53` services> Create a hosted zone. Put in the doman name that you registered earlier like `oxlava.tech` and not with the subdomain `wwww`. It's type is `public hosted zone`. After creating a hosted zone you are provided with 4 `nameservers`. Create a `A record `

