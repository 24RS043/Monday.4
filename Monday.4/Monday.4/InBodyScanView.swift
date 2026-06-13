import SwiftUI
import SwiftData
import PhotosUI

struct InBodyScanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \InBodyRecord.date, order: .reverse) private var records: [InBodyRecord]

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var weightText = ""
    @State private var muscleMassText = ""
    @State private var bodyFatMassText = ""
    @State private var bmiText = ""
    @State private var bodyFatPercentageText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("InBody結果をスキャン") {
                    PhotosPicker("写真を選択", selection: $selectedPhoto, matching: .images)
                    if let selectedImage {
                        Image(uiImage: selectedImage).resizable().scaledToFit().frame(maxHeight: 200)
                        Button("画像から数値を読み取る（OCR・未実装）") { extractValues(from: selectedImage) }
                    }
                }
                Section("計測値") {
                    TextField("体重(kg)", text: $weightText).keyboardType(.decimalPad)
                    TextField("筋肉量(kg)", text: $muscleMassText).keyboardType(.decimalPad)
                    TextField("体脂肪量(kg)", text: $bodyFatMassText).keyboardType(.decimalPad)
                    TextField("BMI", text: $bmiText).keyboardType(.decimalPad)
                    TextField("体脂肪率(%)", text: $bodyFatPercentageText).keyboardType(.decimalPad)
                    Button("保存") { saveRecord() }
                }

                Section("履歴") {
                    if records.isEmpty {
                        Text("まだ記録がありません")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(records) { record in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.headline)

                                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 4) {
                                    GridRow {
                                        Label("\(record.weight, specifier: "%.1f")kg", systemImage: "scalemass")
                                        Label("\(record.muscleMass, specifier: "%.1f")kg", systemImage: "figure.strengthtraining.traditional")
                                    }
                                    GridRow {
                                        Label("\(record.bodyFatMass, specifier: "%.1f")kg", systemImage: "drop")
                                        Label("BMI \(record.bmi, specifier: "%.1f")", systemImage: "ruler")
                                    }
                                    GridRow {
                                        Label("体脂肪率 \(record.bodyFatPercentage, specifier: "%.1f")%", systemImage: "percent")
                                    }
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                                if let photoData = record.photoData, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteRecords)
                    }
                }
            }
            .navigationTitle("InBody")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("グラフ") {
                        InBodyChartView()
                    }
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) { selectedImage = img }
                }
            }
        }
    }

    // TODO: VNRecognizeTextRequestでOCRを実装
    private func extractValues(from image: UIImage) {}

    private func saveRecord() {
        guard
            let w = Double(weightText),
            let mm = Double(muscleMassText),
            let bfm = Double(bodyFatMassText),
            let bmi = Double(bmiText),
            let bfp = Double(bodyFatPercentageText)
        else { return }

        modelContext.insert(InBodyRecord(
            weight: w,
            muscleMass: mm,
            bodyFatMass: bfm,
            bmi: bmi,
            bodyFatPercentage: bfp,
            photoData: selectedImage?.jpegData(compressionQuality: 0.7)
        ))

        weightText = ""
        muscleMassText = ""
        bodyFatMassText = ""
        bmiText = ""
        bodyFatPercentageText = ""
        selectedImage = nil
        selectedPhoto = nil
    }

    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
    }
}
