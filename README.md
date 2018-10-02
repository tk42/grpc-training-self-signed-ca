grpc-training-self-signed-ca
============================

オレオレ認証局

参考資料： [https://qiita.com/NewGyu/items/80bb6a1c9f57ad62c22a](https://qiita.com/NewGyu/items/80bb6a1c9f57ad62c22a)

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
