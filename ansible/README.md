# Ansible
![Static Badge](https://img.shields.io/badge/Team-DevOps-caf0f8?labelColor=2b2d42)
![Static Badge](https://img.shields.io/badge/Admin-Antonio-caf0f8?labelColor=2b2d42)
![Static Badge](https://img.shields.io/badge/Python-3.9.6-orange?style=flat&logo=python&labelColor=2b2d42)
![Static Badge](https://img.shields.io/badge/Ansible-2.15.11-orange?style=flat&logo=ansible&labelColor=2b2d42)

## 개요
- Ansible은 Server, VM 자동 설정, 서비스 자동 배포를 위해 사용합니다.
- Python 기반의 Open Source로 Ansible을 실행하는 환경에 Python이 설치되어 있어야 합니다.

### 구현 항목
- [CentOS / Rocky Linux / Ubuntu 패키지 매니저 최신 업데이트](roles/deploy_node_exporter)
- [Docker 자동 설치](roles/install_docker)
- [Node Exporter 배포](roles/deploy_node_exporter)

### 최소 요구 사항
- `Python >= 3.9.6`
- `Ansible >= 2.15.11`
- `jinja >= 3.1.4`

## 명령어 가이드

---
```bash
# Host SSH key 복사
ssh-copy user@ip

# Ansible Playbook 유효성 검증
ansible-playbook --check -i inventory/hosts main_playbook.yaml

# Ansible Playbook 실행
ansible-playbook -i inventory/hosts main_playbook.yaml

# Ansible Community Package 설치
ansible-galaxy collection install -r requirements.yaml
```

## 추가 자료
- [Ansible 개념 및 기능 가이드](Guide.md)
- [Ansible 공식 문서](https://docs.ansible.com/ansible/latest/getting_started/index.html)
- [Ansible built-in 모듈](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
- [Ansible 조건문](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)
- [Ansible Payload 명세](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html)
- [Ansible Community Module - Docker](https://docs.ansible.com/ansible/latest/collections/community/docker/index.html)