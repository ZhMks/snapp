//
//  FireBaseAuthService.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth

final class FireBaseAuthService {

    private var verificationID: String?

    func signUpUser(phone: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            if error != nil {
                completion(false)
            }

            if let verificationID = verificationID {
                self?.verificationID = verificationID
                print(verificationID)
                completion(true)
            }
        }
    }

    func verifyCode(code: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in
            if error != nil {
                completion(false)
            }
            if result != nil {
                completion(true)
            }
        }
    }
}


//AD8T5ItslvzcjMnkfgm07fDTmkLL9S9SXy22nM26uoqrpLmfYlEg3UFpGLNulDPA9xc-wf5UeEl8kTK8-Opg-Us-YOtQP3HGaSb9iPjdMu_JyNS2ZLl626XoxdarAeEStiBuHB4_P6dmWmM1P-uIc9ErB9SaTNWVA9s7FsaIQ-PrVGdqgbHFRIwXWKhHNg_TSFh5sxlKVi0J1bs6bc-o2nCgovCgRp2Wyxm07DSlTuDLPG6p6_UJuVg

//AD8T5IuEsCxJFiZqzsLdr-Qj7_WXyXEW-vPyefmqe0HMb4e9IMI3I9yymmDrkpR0vEIE0Lc6eUesrtnY7qw1hpfSUDxcUecUyAXkJzDDY3bPYykrLoxegtddlydPAP_pVvpMZudx0PNAkrlMCgxs1cXf8C_-Ce_4t3pHs2Dnee6IyRdwzzZfy3Wbpp1WORoxOsJXiuN4ySnP9IfOLRT8dZ7EgOiphYNDM6D8TKpq17jSFmfVGk5hqSs

//AD8T5IvLjPmdqMrwCWFpMUNWuZdJCpAg3sJtxJzGadWE45AKL4AQivK3PlvqDRahLV-GiSdIiFa-4nD5aPW3kxjUudJnWR_8oyzGW-b7T-nS94H9Q8x-Bs5HYKTosHJlLD_Sc2dSQz_9jc56KRISFBW-rKNi6p-UJ6oAyDZEzgtveBk1Qdunt2aDsLhhDWAnQjNuVmrm1l-PGliaCJnDOddJJTbNZW1PFh5sNyzG7Yh1WqkcTRzegic
