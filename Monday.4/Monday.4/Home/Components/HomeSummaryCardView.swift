import SwiftUI

struct HomeSummaryCardView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let unit: String
    let goalText: String
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(iconColor)
                .frame(width: 34, height: 34)
                .background(iconColor.opacity(0.16))
                .clipShape(Circle())

            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(2)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 25, weight: .bold))

                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(goalText)
                .font(.caption2)
                .foregroundStyle(.secondary)

            ProgressView(value: progress)
                .tint(iconColor)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 154, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}
