/*
 * Copyright 2017 shrtlist.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import ContactsUI

class EmployeeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var yearsEmployedLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    var employee: Employee? {
        didSet {
            configureView()
        }
    }

    // MARK: Private property

    private lazy var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    // MARK: View configuration

    private func configureView() {
        guard let emp = employee else {
            clearView()
            return
        }

        // Update the user interface for the detail item.
        nameLabel.text = emp.name
        jobTitleLabel.text = emp.jobTitle
        dateOfBirthLabel.text = shortDateFormatter.string(from: emp.dateOfBirth! as Date)
        yearsEmployedLabel.text = String(emp.yearsEmployed)
        photoImageView.image = UIImage(data: emp.photo! as Data)
    }

    private func clearView() {
        nameLabel.text = nil
        jobTitleLabel.text = nil
        dateOfBirthLabel.text = nil
        yearsEmployedLabel.text = nil
        photoImageView.image = nil
    }
}

