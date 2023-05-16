# VelogOniOS
Refactoring to MVVM

https://github.com/SSUDevelog/VelogInMobile

MVC로 진행되었던 위 링크 프로젝트를 MVVM으로 리팩토링합니다.

## Behance
https://www.behance.net/gallery/161537145/Velog-In-Mobile

## 프로젝트
 
- 기획 배경

Velog는 Medium이나 Tistory와 비슷하게 IT 업계 사람들이 주로 사용하며, 개발 관련 글들을 읽고 쓸 수 있는 웹 서비스입니다.

Velog에 유익한 글이 많지만, 현재 웹서비스로만 운영되는 Velog는 유저의 관심사에 맞는 글을 추천하거나, 유저가 다른 Velog 유저를 구독하여 지속해서 구독한 유저의 글을 볼 수 있는 기능이 없어 불편한 점이 있습니다.

기술 블로그 성격상 웹 서비스와 함께 앱 형태로 출시된다면 많은 사람이 편리하게 기술 글들을 읽을 수 있겠다고 생각하여 Velog 웹 서비스를 앱 서비스 형태로 만들었습니다.

- 주요 기능

1. 키워드별 글 추천 기능
2. 유저 구독 기능
3. 글 스크랩 기능
4. 구독한 유저가 새로운 글을 썼을 때 푸쉬 알림 기능


- Library

라이브러리 | 사용 목적 | Version | Management Tool
:---------:|:----------:|:---------: |:---------:
 Moya | 서버 통신 | master | SPM
 RxSwift  | 비동기 처리 | 6.5.0 | SPM
 Realm  | 로컬 DB | master | SPM
 SnapKit | UI Layout | master | SPM
 Kingfisher  | 이미지 캐싱 | master | SPM
 
## iOS Developers


| 홍준혁 | 주현아 |
| :---------:|:----------:|
| [lms7802](https://github.com/hongjunehuke) | [JuHyeonAh](https://github.com/JuHyeonAh) |
