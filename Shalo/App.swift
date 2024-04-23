import Foundation

struct App {
    let filters: [Filter]
    let tools: Array<ToolEnum>
    public static let shared = `default`
}

extension App {
    private static let `default` = App(
        filters: [
            PassthroughFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            SepiaFilter(),
            VintageFilter(),
            ClampFilter(),
            RetroFilter(),
            ProcessFilter(),
            ComicFilter(),
            ColorInvertFilter(),
            HalfToneFilter(),
            BlurFilter(blurRadius: 30),
            MonoFilter(),
            MonochromeFilter(),
            NoirFilter()
        ],
      tools: [
        .colourCorrection(tool: LightTool()),
        .exposureTool(tool: ExposureTool()),
        .highlightShadowTool(tool: HighlightShadowTool()),
        .vibranceTool(tool: VibranceTool()),
        .straightenTool(tool: StraightenTool()),
        .speed
      ]
    )
    
    private static let many = App(
        filters: [
            PassthroughFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ClampFilter()
        ],
        tools: [.colourCorrection(tool: LightTool())]
    )
    
    private static let variant2 = App(
        filters: [
            PassthroughFilter(),
            ComicFilter()
        ],
        tools: [.colourCorrection(tool: LightTool())]
    )
    
    private static let composite = App(
        filters: [
            PassthroughFilter(),
            OldFilmFilter() + VignetteFilter(),
            BlurFilter(blurRadius: 20) + SharpAndWarmFilter(inputSharpness: 0.7),
            ClampFilter() + VignetteFilter(),
            ComicFilter() + VignetteFilter()
        ],
        tools: [.colourCorrection(tool: LightTool())]
    )
    
    private static let slowFilter = App(
        filters: [
            PassthroughFilter(),
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7)
        ],
        tools: [.colourCorrection(tool: LightTool())]
    )
}
