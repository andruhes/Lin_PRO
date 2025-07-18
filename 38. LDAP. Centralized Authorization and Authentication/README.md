# Домашнее задание к занятию 38 - "LDAP. Централизованная авторизация и аутентификация"

## Описание домашнего задания

1) Установить FreeIPA
2) Написать Ansible-playbook для конфигурации клиента

Дополнительное задание
3)* Настроить аутентификацию по SSH-ключам
4)** Firewall должен быть включен на сервере и на клиенте


---

## Выполнение     

Подготовлен [Vagrantfile](./Vagrantfile), роли [freeipa_server](./ansible/roles/freeipa_server/) и [freeipa_client](./ansible/roles/freeipa_client/), а так же [ansible playbook](./ansible/provision.yml) разворачивающий данный стенд.

Использование:    
```bash
vagrant up
```

---
