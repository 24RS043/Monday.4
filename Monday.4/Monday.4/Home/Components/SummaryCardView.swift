import SwiftUI

struct SummaryCardView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let unit: String
    let target: String
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.title2.bold())

                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(target)
                .font(.caption2)
                .foregroundStyle(.secondary)

            ProgressView(value: progress)
                .tint(iconColor)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
