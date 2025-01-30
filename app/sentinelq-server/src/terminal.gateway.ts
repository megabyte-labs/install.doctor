/*
 * @file terminal.gateway.ts
 * @description WebSocket gateway for managing terminal streams
 */

import { WebSocketGateway, SubscribeMessage, WebSocketServer } from '@nestjs/websockets';
import { TerminalService } from './terminal.service';
import { Server } from 'socket.io';

@WebSocketGateway({ cors: true })
export class TerminalGateway {
    @WebSocketServer()
    server: Server;

    constructor(private terminalService: TerminalService) {}

    afterInit() {
        this.terminalService.setSocketServer(this.server);
    }

    @SubscribeMessage('create-terminal')
    handleCreateTerminal(client: any, payload: { id: string }) {
        this.terminalService.createTerminal(payload.id);
    }

    @SubscribeMessage('write-to-terminal')
    handleWriteToTerminal(client: any, payload: { id: string; command: string }) {
        this.terminalService.writeToTerminal(payload.id, payload.command);
    }

    @SubscribeMessage('close-terminal')
    handleCloseTerminal(client: any, payload: { id: string }) {
        this.terminalService.closeTerminal(payload.id);
    }
}
