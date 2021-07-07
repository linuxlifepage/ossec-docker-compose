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

### Knowly ossec auth pass for agents

```
docker exec ossec-server_app_1 cat /var/ossec/logs/ossec.log | grep authentication
```

### Check status OSSEC

```
docker exec ossec-server_app_1 /var/ossec/bin/ossec-control status
```
