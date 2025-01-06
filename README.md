# 포켓몬 도감 앱

</br>

## 프로젝트 소개
[포켓몬 API](https://pokeapi.co/)를 활용한 iOS 포켓몬 도감 애플리케이션입니다.   
사용자는 포켓몬 목록을 확인하고 각 포켓몬의 상세 정보를 볼 수 있습니다.

![Simulator Screen Recording - iPhone 16 Pro - 2025-01-06 at 10 16 09](https://github.com/user-attachments/assets/5ff0eb53-5417-4aee-9ab3-7714a2949456)

</br>

## 주요 기능
* 포켓몬 목록 조회 (무한 스크롤)
* 포켓몬 상세 정보 조회 (이름, 타입, 키, 몸무게)
* 한글 이름 지원
* 이미지 캐싱
* 네트워크 에러 처리

</br>

## 기술 스택
* Swift
* UIKit
* RxSwift
* SnapKit
* MVVM 아키텍처

</br>

## 주요 구성요소

### Network
* `NetworkManager`: 싱글톤 패턴을 사용한 네트워크 통신 관리
* `NetworkCache`: 데이터 캐싱 처리
* `NetworkResponseHandler`: 네트워크 응답 처리 및 에러 핸들링

### Models
* `Pokemon`: 기본 포켓몬 정보 모델
* `PokemonDetails`: 상세 포켓몬 정보 모델
* `PokemonList`: 포켓몬 목록 응답 모델
* `PokemonType`: 포켓몬 타입 정보 모델

### ViewModels
* `MainViewModel`: 메인 화면 비즈니스 로직 처리
* `DetailViewModel`: 상세 화면 비즈니스 로직 처리
* `PokeCollectionViewCellViewModel`: 셀 데이터 처리

### Views
* `MainViewController`: 포켓몬 목록 화면
* `DetailViewController`: 포켓몬 상세 정보 화면
* `PokeCollectionViewCell`: 포켓몬 셀 구현

### Utils
* `PokeURLFormatter`: API URL 생성 유틸리티
* `PokemonTranslator`: 영문-한글 이름 변환
* `SingleTranslator`: RxSwift Single 변환 유틸리티

</br>

## 아키텍처
* MVVM 디자인 패턴 적용

</br>

## 주요 특징

### 반응형 프로그래밍
* RxSwift를 활용한 데이터 바인딩
* 비동기 네트워크 통신 처리

### 효율적인 리소스 관리
* 이미지 캐싱
* 메모리 누수 방지를 위한 메모리 관리

### 사용자 경험
* 무한 스크롤 구현
* 에러 처리 및 사용자 피드백

</br>

## 라이브러리
* RxSwift
* SnapKit

이 프로젝트는 포켓몬 API를 활용하여 사용자 친화적인 인터페이스를 제공하며, MVVM 아키텍처와 반응형 프로그래밍을 통해 효율적인 데이터 처리와 UI 업데이트를 구현했습니다.
