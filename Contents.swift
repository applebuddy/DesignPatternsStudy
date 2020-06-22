
// MARK: - MVVM(Model-View-ViewModel) DesignPattern Study

// - MVVM(모델-뷰-뷰모델) 학습 정리

import PlaygroundSupport
import UIKit

// MARK: - Model

// - 예를 들면, pets를 채택하는 앱의 일부로서 Pet View를 만들 수 있습니다. 먼저, 아래와 같은 코드를 작성합니다.
public class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }

    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage

    public init(name: String,
                birthday: Date,
                rarity: Rarity,
                image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// 위에서는, Pet이란 이름의 Model을 정의했습니다. 모든 Pet들은 이름, 생일, 희귀성, 이미지를 갖고 있습니다. 당신은 이러한 프로퍼티들을 View로 보여주고 싶습니다. 하지만, birthday, rarity는 직접적으로 표출될 수 없습니다. 그들은 ViewModel로서 먼저 변환되어야 합니다.

// 그 다음, playground 끝에 다음과 같은 코드를 작성해줍니다.

// MARK: - ViewModel

public class PetViewModel {
    // 1) pet
    private let pet: Pet
    private let calendar: Calendar

    public init(pet: Pet) {
        self.pet = pet
        calendar = Calendar(identifier: .gregorian)
    }

    // 2) name
    public var name: String {
        return pet.name
    }

    public var image: UIImage {
        return pet.image
    }

    // 3) ageText
    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        let age = components.year!
        return "\(age) years old"
    }

    // 4) adoptionFeeText
    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}

// 위의 코드는 아래와 같은 작업을 수행 했습니다.
// 1. 먼저, pet, calendar로 불리는 두개의 private 프로퍼티를 생성했으며, init(pet:)생성자에서 초기화 하고 있습니다.
// 2. 그 다음, name, image을 위한 두개의 계산 프로퍼티를 선언했습니다. name, image는 상대적으로 pet의 이름과 이미지를 반환할때 사용됩니다. 이는 당신이 수행할 수 있는 가장 간단한 변형의 예인 변형 없이 값을 반환하는 예입니다. 만약 모든 펫의 이름 접두어를 수정하고 싶다면, ViewModel의 해당 부분에서 쉽게 이름 구조를 수정할 수 있게 됩니다.
// 3. 세번째로, 또다른 계산 프로퍼티로서 ageText를 선언합니다. ageText 값 반환시에는 오늘부터 pet의 생일까지의 시간 차이를 계산하기 위해 calendar를 활용하고 있습니다. 여기에 "years old"문자열이 따라오게 됩니다. 이후 어떠한 String 문자열 포멧 작업 없이 해당 값(ageText)를 뷰에 띄울 수 있습니다.
// 4. 마지막으로, 계산 프로퍼티로서 adoptionFeeText를 생성할 수 있습니다. adoptionFeeText에서는 rarity에 기반한 pet의 입양비용을 결정할 수 있습니다. 또한 이러한 값을 String 문자열로서 반환할 수 있습니다.

// 이제 부터 이러한 pet의 정보를 표출하기 위한 UIView가 필요합니다. Model, ViewModel에 이은 View입니다.

// MARK: - View

public class PetView: UIView {
    public let imageView: UIImageView
    public let nameLabel: UILabel
    public let ageLabel: UILabel
    public let adoptionFeeLabel: UILabel

    public override init(frame: CGRect) {
        var childFrame = CGRect(x: 0,
                                y: 16,
                                width: frame.width,
                                height: frame.height / 2)
        imageView = UIImageView(frame: childFrame)
        imageView.contentMode = .scaleAspectFit

        childFrame.origin.y += childFrame.height + 16
        childFrame.size.height = 30

        nameLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center

        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center

        childFrame.origin.y += childFrame.height
        adoptionFeeLabel = UILabel(frame: childFrame)
        adoptionFeeLabel.textAlignment = .center

        super.init(frame: frame)

        backgroundColor = .white
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(adoptionFeeLabel)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}

// 바로 위 코드에서 4개의 서브뷰(subView)를 포함한 PetView를 선언하고 있습니다. 해당 뷰에서 pet의 이미지, 그 외 이름, 나이, 입양비를 표현하는 세개의 라벨을 띄웁니다.
// 이때 각각의 뷰에 대한 위치를 init(frame:)에서 설정할 수 있습니다. 마지막으로, 해당 뷰가 지원되지 않는다면, init?(coder:)에서 fatalError를 실행하도록 되어 있습니다.

// 이제, Model, ViewModel, View가 준비되었으며, 클래스들을 동작시킬 준비가 되었습니다. 이어서 아래의 코드를 작성해 봅니다.

// MARK: - Example to Action

// 1
let birthday = Date(timeIntervalSinceNow: -2 * 85400 * 366)
let image = UIImage(named: "stuart")!
let stuart = Pet(name: "Stuart",
                 birthday: birthday,
                 rarity: .veryRare,
                 image: image)

// 2
let viewModel = PetViewModel(pet: stuart)

// 3
let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
let view = PetView(frame: frame)

// 4
view.nameLabel.text = viewModel.name
view.imageView.image = viewModel.image
view.ageLabel.text = viewModel.ageText
view.adoptionFeeLabel.text = viewModel.adoptionFeeText

// 5
PlaygroundPage.current.liveView = view
