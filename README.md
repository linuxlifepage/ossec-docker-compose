## Commands

### Manual added agents

``` 
docker exec -it ossec-server_app_1 /var/ossec/bin/manage_agent
```

### Restart the OSSEC manager

```
docker exec -it ossec-server_app_1 /var/ossec/bin/ossec-control restart
```

### RUN to container

```
docker exec -it ossec-server_app_1 bash
```

### Find out where the ossec auth pass for agents

```
docker exec ossec-server_app_1 cat /var/ossec/logs/ossec.log | grep authentication
```

### Check status OSSEC

```
docker exec ossec-server_app_1 /var/ossec/bin/ossec-control status
```

### Add agent on agent

First create /var/ossec/etc/authd.pass with pass

And added agent

```
/var/ossec/bin/agent-auth -m IP_OSSEC_SERVER -p 1515 -P /var/ossec/etc/authd.pass
```
