import Foundation

struct HealthCalculator {

    // 年齢
    static func age(from birthDate: Date) -> Int {

        let calendar = Calendar.current

        return calendar.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    // BMI
    static func bmi(height: Double, weight: Double) -> Double {

        guard height > 0 else { return 0 }

        let meter = height / 100

        return weight / (meter * meter)
    }

    // 推定体脂肪率
    static func bodyFat(
        height: Double,
        weight: Double,
        age: Int,
        gender: String
    ) -> Double {

        let bmiValue = bmi(height: height, weight: weight)

        if gender == "男性" {
            return 1.20 * bmiValue + 0.23 * Double(age) - 16.2
        } else {
            return 1.20 * bmiValue + 0.23 * Double(age) - 5.4
        }
    }

    // 除脂肪体重
    static func leanBodyMass(
        weight: Double,
        bodyFat: Double
    ) -> Double {

        weight * (1 - bodyFat / 100)
    }

    // 推定筋肉量
    static func muscleMass(
        weight: Double,
        bodyFat: Double
    ) -> Double {

        let lbm = leanBodyMass(weight: weight, bodyFat: bodyFat)

        return lbm * 0.55
    }

    // 基礎代謝(BMR)
    static func bmr(
        height: Double,
        weight: Double,
        age: Int,
        gender: String
    ) -> Double {

        if gender == "男性" {
            return 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            return 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
    }

    // 消費カロリー(TDEE)
    static func tdee(
        bmr: Double,
        activityLevel: String
    ) -> Double {

        switch activityLevel {

        case "低い":
            return bmr * 1.2

        case "普通":
            return bmr * 1.55

        case "高い":
            return bmr * 1.725

        default:
            return bmr
        }
    }
}
