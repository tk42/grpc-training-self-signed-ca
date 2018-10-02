grpc-training-self-signed-ca
============================

オレオレ認証局

## Create CA

```
$ docker-compose run create_ca_cert
```

## Create server cert

```
$ docker-compose run create_server_cert dev-grpc-server.example.com
```

## Create client cert

```
$ docker-compose run create_client_cert service1
$ docker-compose run create_client_cert service2
```
