
// MARK: - MVVM(Model-View-ViewModel) DesignPattern Study

// MARK: - MVVM(모델-뷰-뷰모델) 학습 정리

import PlaygroundSupport
import UIKit

// MARK: Model

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

    public init(name: String, birthday: Date, rarity: Rarity, image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// 위에서는, Pet이란 이름의 Model을 정의했습니다. 모든 Pet들은 이름, 생일, 희귀성, 이미지를 갖고 있습니다. 당신은 이러한 프로퍼티들을 View로 보여주고 싶습니다. 하지만, birthday, rarity는 직접적으로 표출될 수 없습니다. 그들은 ViewModel로서 먼저 변환되어야 합니다.

// 그 다음, playground 끝에 다음과 같은 코드를 작성해줍니다.

// MARK: ViewModel

public class PetViewModel {
    // 1) pet : Pet 객체를 생성합니다. 나이 연산을 위해 Calendar도 생성합니다.
    private let pet: Pet
    private let calendar: Calendar

    public init(pet: Pet) {
        self.pet = pet
        calendar = Calendar(identifier: .gregorian)
    }

    // 2) name : 펫의 이름을 반환합니다.
    public var name: String {
        return pet.name
    }

    // image : 펫의 이미지를 반환합니다.
    public var image: UIImage {
        return pet.image
    }

    // 3) ageText : 펫의 나이를 연산하며 반환합니다. 몇살인지를 표출합니다.
    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        let age = components.year!
        return "\(age) years old"
    }

    // 4) adoptionFeeText : 해당 펫의 희귀성에 따른 가격을 결정합니다.
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

// MARK: View

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
        nameLabel.textAlignment = .center

        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        ageLabel.textAlignment = .center

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
let mungGu = Pet(name: "mungGu",
                 birthday: birthday,
                 rarity: .veryRare,
                 image: image)

// 2
let viewModel = PetViewModel(pet: mungGu)

// 3
let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
let view = PetView(frame: frame)

// 4

/*
 // 4-1) viewModel extension -> configure 메서드 미사용 시
 view.nameLabel.text = viewModel.name
 view.imageView.image = viewModel.image
 view.ageLabel.text = viewModel.ageText
 view.adoptionFeeLabel.text = viewModel.adoptionFeeText
 */
// 4-2) viewModel extension -> configure 메서드 사용 시
viewModel.configure(view)

// 5
PlaygroundPage.current.liveView = view

// 1 ~ 5 까지의 과정을 보도록 하겠습니다.
// 1. stuart라는 새로운 Pet을 생성했습니다.
// 2. stuart를 사용해서 viewModel을 생성했습니다.
// 3. iOS에서 일반적인 frame size를 넘겨서 view를 생성했습니다.
// 4. viewModel을 사용해서 subviews를 설정했습니다.
// 5. 마지막으로 PlaygroundPage에 view를 설정했습니다.
// .   - PlaygroundPage.current.liveView -> 해당 코드는 playground에게 standard Assistant editor에 view를 렌더링 하라는 의미입니다.
// -> 해당 결과를 보기 위해서는 Editor -> Live View를 선택해서 렌더링 된 View를 볼 수 있습니다.

// - 결과적으로 나오는 뷰의 동물은 Stuart가 맞나요? 그는 cookie monster입니다. 또한 이놈은 매우 희귀(rare)합니다.
// 이제 마지막으로 코드를 작성해 봅니다. 해당 예제에 적용할 수 있는 코드입니다. 다음의 PetViewModel extension 코드를 작성해좁니다.
// 아래의 exntension코드 내 configure 메서드를 사용하면, viewModel을 사용해서 view를 설정할 수 있게 됩니다.
// 해당 extension 코드는 view의 설정 코드를 viewModel 내에서 처리할 수 있는 산뜻한 방법이 됩니다. 실전에서 이런 구현이 필요할 수도, 원하지 않을 수도 있습니다. 어쨋든, 만약 view에 대한 설정을 viewModel에서 처리하고 싶다면, 아래와 같은 구현은 유용하게 사용할 수 있습니다.
// 만약 viewModel이 단일 뷰만 관리한다면 아래와 같이 viewModel에서 처리할 수 있겠지만, 하나의 viewModel이 다수의 뷰를 관리한다면, 별개로 처리하는게 좋을 수도 있습니다.
extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}

// MARK: - MMVM을 구현할 때 무엇을 주의해야 할까요?

// var S = "20200523"
// let index = S.startIndex
// S.insert("-", at: S.index(index, offsetBy: 4))
// S.insert("-", at: S.index(index, offsetBy: 7))
// print(S)

var S = [1, 2, 3, 4, 5]

// MARK: MVVM 패턴 사용 간 주의해야 할 사항

// What should you be careful about?
// MVVM 사용 시 무엇을 주의해야 할까?

// 만약 많은 Model-to-View 변환을 요구하는 경우에 MVVM는 유용하게 사용될 수 있습니다.
// 하지만, 모든 객체들이 모델, 뷰, 뷰모델의 범주에 항상 딱 맞지는 않을 것입니다., 이때는 대신 다른 디자인 패턴들과 함께 조합을 해서 MVVM을 사용해야만 합니다.
//
// 무엇보다도, 처음으로 앱을 만들어 본다면, MVVM은 매우 유용하지 못할 수 있습니다. MVC는 개발의 시작점으로 좋은 패턴입니다. MVC(Model-View-Controller) 디자인패턴은 Cocoa에서 기반으로 사용중인 패턴일 뿐만 아니라 다른 패턴에 비해 비교적 간단하게 구현할 수 있는 장점이 있기 때문입니다. 앱의 요구사장일 변경될 때, 당신은 이러한 변화된 요구사항에 맞게 다른 디자인 패턴을 선택해야할 필요를 느낄 수 있습니다. 이런 상황이 오게 된다면, 앱 내에 MVVM을 적용해보는 것은 좋습니다.
//
// 그때 가서 MVVM 패턴을 사용하는 것에 겁먹지 마세요. 대신 미리 준비 하세요.
