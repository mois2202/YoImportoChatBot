
const IMAGE_BASE_PATH = "./src/Media/MediaToSend/Images/";
const VIDEO_BASE_PATH = "./src/Media/MediaToSend/Video/";
const AUDIO_BASE_PATH = "./src/Media/MediaToSend/Audio/";
const DOC_BASE_PATH = "./src/Media/MediaToSend/Doc/";
const PDF_BASE_PATH = "./src/Media/MediaToSend/PDF/";

export const sendImage = (imageName: string, body?: string): { body?: string; mediaPath: string }[] => {
    const mediaPath = IMAGE_BASE_PATH + imageName + ".jpg";
    const ImageToSend = [{ body, mediaPath }];
    return ImageToSend;
};

export const sendVideo = (videoName: string, body?: string): { body?: string; mediaPath: string }[] => {
    const mediaPath = VIDEO_BASE_PATH + videoName + ".mp4";
    const VideoToSend = [{ body, mediaPath }];
    return VideoToSend;
};

export const sendAudio = (audioName: string, body?: string): { body?: string; mediaPath: string }[] => {
    const mediaPath = AUDIO_BASE_PATH + audioName + ".mp3";
    const AudioToSend = [{ body, mediaPath }];
    return AudioToSend;
};

export const sendDoc = (docName: string, body?: string): { body?: string; mediaPath: string }[] => {
    const mediaPath = DOC_BASE_PATH + docName + ".doc";
    const DocToSend = [{ body, mediaPath }];
    return DocToSend;
};

export const sendPDF = (pdfName: string, body?: string): { body?: string; mediaPath: string }[] => {
    const mediaPath = PDF_BASE_PATH + pdfName + ".pdf";
    const PDFToSend = [{ body, mediaPath }];
    return PDFToSend;
};

export const sendMedia= (type : string, fileName: string, body?: string) => {
    if(type == "AUDIO"){
        return sendAudio(fileName, body);
    }
    if(type == "IMAGE"){
        return sendImage(fileName, body);
    }
    if(type == "VIDEO"){
        return sendVideo(fileName, body);
    }
    if(type == "DOC"){
        return sendDoc(fileName, body);
    }
    if(type == "PDF"){
        return sendPDF(fileName, body);
    }
    return null;
}