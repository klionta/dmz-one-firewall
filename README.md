# dmz-one-firewall
A simulation of a company network that includes a private LAN, a DMZ server, and a firewall that controls and filters traffic. The firewall prevents direct communication between the internal LAN and the external Internet, allowing only controlled access through the DMZ.

## Basic Structure
There are four folders — **attacker**, **dmz**, **db**, and **firewall** — described below:

### DMZ
This folder contains the functionality of the DMZ network, which consists of a server in the subnet `172.10.0.0/24` accessible from the external network.

When someone connects successfully to that server, the following message is displayed: ```Hello from DMZ web server! Try /db to query the DB.```

The DMZ network is authorized to access the database in the internal network at IP `172.19.0.2` on port `5432`.  
The database contains a user with the username **test** and password **test**.
