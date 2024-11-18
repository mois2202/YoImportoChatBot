const IMAGE_BASE_PATH = "./src/Media/MediaToSend/Images/";
const VIDEO_BASE_PATH = "./src/Media/MediaToSend/Video/";
const AUDIO_BASE_PATH = "./src/Media/MediaToSend/Audio/";
const DOC_BASE_PATH = "./src/Media/MediaToSend/Doc/";
const PDF_BASE_PATH = "./src/Media/MediaToSend/PDF/";
export const sendImage = (imageName, body) => {
    const mediaPath = IMAGE_BASE_PATH + imageName + ".jpg";
    const ImageToSend = [{ body, mediaPath }];
    return ImageToSend;
};
export const sendVideo = (videoName, body) => {
    const mediaPath = VIDEO_BASE_PATH + videoName + ".mp4";
    const VideoToSend = [{ body, mediaPath }];
    return VideoToSend;
};
export const sendAudio = (audioName, body) => {
    const mediaPath = AUDIO_BASE_PATH + audioName + ".mp3";
    const AudioToSend = [{ body, mediaPath }];
    return AudioToSend;
};
export const sendDoc = (docName, body) => {
    const mediaPath = DOC_BASE_PATH + docName + ".doc";
    const DocToSend = [{ body, mediaPath }];
    return DocToSend;
};
export const sendPDF = (pdfName, body) => {
    const mediaPath = PDF_BASE_PATH + pdfName + ".pdf";
    const PDFToSend = [{ body, mediaPath }];
    return PDFToSend;
};
export const sendMedia = (type, fileName, body) => {
    if (type == "AUD") {
        return sendAudio(fileName, body);
    }
    if (type == "IMA") {
        return sendImage(fileName, body);
    }
    if (type == "VID") {
        return sendVideo(fileName, body);
    }
    if (type == "DOC") {
        return sendDoc(fileName, body);
    }
    if (type == "PDF") {
        return sendPDF(fileName, body);
    }
    return null;
};
