//
//  SignRepository.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/02.
//

import Foundation

protocol SignRepository {
    func signIn(body: SignInRequest, completion: @escaping (NetworkResult<Any>) -> Void)
    func signOut(body: SignOutRequest, completion: @escaping (NetworkResult<Any>) -> Void)
    func signUp(body: SignUpRequest, completion: @escaping (NetworkResult<Any>) -> Void)
}
