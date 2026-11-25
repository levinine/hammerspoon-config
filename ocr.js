ObjC.import('Vision');
ObjC.import('Foundation');
ObjC.import('AppKit');

function run(argv) {
    const image = $.NSImage.alloc.initWithContentsOfFile(argv[0]);
    if (!image || image.isNil()) return '';
    const rep = $.NSBitmapImageRep.imageRepWithData(image.TIFFRepresentation);
    const handler = $.VNImageRequestHandler.alloc.initWithDataOptions(rep.representationUsingTypeProperties($.NSBitmapImageFileTypePNG, $()), $());
    const request = $.VNRecognizeTextRequest.alloc.init;
    request.recognitionLevel = 0; // accurate
    request.usesLanguageCorrection = true;
    handler.performRequestsError($([request]), $());

    const lines = [];
    const results = request.results;
    for (let i = 0; i < results.count; i++) {
        lines.push(ObjC.unwrap(results.objectAtIndex(i).topCandidates(1).objectAtIndex(0).string));
    }
    return lines.join('\n');
}
