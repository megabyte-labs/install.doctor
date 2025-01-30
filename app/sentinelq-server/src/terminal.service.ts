/*
 * @file terminal.service.ts
 * @description Handles shell processes using node-pty
 */

import { Injectable } from '@nestjs/common';
import { spawn } from 'node-pty';
import { Server } from 'socket.io';

@Injectable()
export class TerminalService {
    private terminals: Map<string, any> = new Map();
    private io: Server;

    setSocketServer(io: Server) {
        this.io = io;
    }

    createTerminal(id: string, shell: string = 'bash', cols: number = 80, rows: number = 24) {
        const term = spawn(shell, [], { cols, rows, cwd: process.env.HOME, env: process.env });
        this.terminals.set(id, term);

        term.onData((data: string) => {
            this.io.emit(`terminal-output-${id}`, data);
        });
    }

    writeToTerminal(id: string, command: string) {
        if (this.terminals.has(id)) {
            this.terminals.get(id).write(command + '\n');
        }
    }

    closeTerminal(id: string) {
        if (this.terminals.has(id)) {
            this.terminals.get(id).kill();
            this.terminals.delete(id);
        }
    }
}
