/*
 * @file preload.ts
 * @description Electron preload script to expose secure APIs to renderer
 */

import { contextBridge, ipcRenderer } from 'electron';

contextBridge.exposeInMainWorld('electronAPI', {
    sendToBackend: (channel: string, data: any) => ipcRenderer.send(channel, data),
    receiveFromBackend: (channel: string, callback: (data: any) => void) => {
        ipcRenderer.on(channel, (_event, data) => callback(data));
    }
});
