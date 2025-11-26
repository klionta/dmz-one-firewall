# dmz-one-firewall
A simulation of a company network that includes a private LAN, a DMZ server, and a firewall that controls and filters traffic. The firewall prevents direct communication between the internal LAN and the external Internet, allowing only controlled access through the DMZ.

## Basic Structure
There are four folders — **attacker**, **dmz**, **db**, and **firewall** — described below:

### DMZ
This folder contains the functionality of the DMZ network, which consists of a server in the subnet `172.18.0.0/24` accessible from the external network.

When someone connects successfully to that server, the following message is displayed: ```Hello from DMZ web server! Try /db to query the DB.```

The DMZ network is authorized to access the database in the internal network at IP `172.19.0.2` on port `5432`.  
The database contains a user with the username **test** and password **test**.

### Firewall
The default firewall policy is set to drop, and any pre-existing connections are allowed. From the outside network to the DMZ, the only new connections that are permitted are HTTP. The DMZ network can request resources from the database located in the internal (private LAN) network using a PostgreSQL connection. Communication from the outside network to the internal network is not allowed; however, if the connection is initiated by the internal network or the DMZ, it is permitted. All traffic initiated from the internal network or the DMZ is routed through NAT. All networks communicate only through the firewall, with no direct communication between them. The firewall interface IP addresses end with .254 (instead of the typical .1), because .1 is reserved by the Docker container when using a bridge network.

### DB - Internal
This network is the private LAN that contains a database at IP address `172.19.0.2` on port `5342`. Only the DMZ is allowed to access this resource. The subnet assigned to this network is `172.19.0.0/24`.

### Atacker
This host is placed in the outside network. The outside network uses IP addresses from the `172.20.0.0/24` subnet, and the attacker's host has the IP address `172.20.0.3`. We used this host to test our firewall. This host cannot send packets to the internal network, but it can connect to the DMZ network using HTTP.

> [!NOTE]
> **CHECK the ```dmz-one-firewall.pdf``` to understand the network stucture.**

## Instalation and Setup Guidelines
Clone the repository:

```
git clone https://github.com/klionta/dmz-one-firewall.git 
```

Build the containers (dmz-web, internal-db, attacker, firewall):

```
docker compose up --build -d
```

Configure the routing tables of each network:

```
docker exec -it internal-db bash
```

Run:
```
ip route add 172.20.0.0/24 via 172.19.0.254 
ip route add 172.18.0.0/24 via 172.19.0.254
```

```
docker exec -it dmz-web bash
```

Run:
```
ip route add 172.20.0.0/24 via 172.18.0.254 
ip route add 172.19.0.0/24 via 172.18.0.254
```

```
docker exec -it outside bash
```

Run:
```
ip route add 172.18.0.0/24 via 172.20.0.254 
ip route add 172.19.0.0/24 via 172.20.0.254
```

## Example
From dmz-web container run:

```
psql -h 172.19.0.2 -p 5342 -U test

```

And then type the password `test`. This proves that dmz can access the dm in the private LAN.

From attacker container run:
```
postsql -h 172.19.0.2 -p 5342 -U test
```

Should fail and any try for communication such as ping or curl. This proves that the attacker cannot access the internal db. Again from attacker ask an http resource from dmz:

```
curl http://172.19.0.2/
```

Should succeed.





