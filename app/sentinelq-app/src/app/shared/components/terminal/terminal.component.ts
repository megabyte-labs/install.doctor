/*
 * @file terminal.component.ts
 * @description Angular component to display terminal output
 */

import { Component, ElementRef, ViewChild, AfterViewInit } from '@angular/core';
import { Terminal } from 'xterm';
import { TerminalService } from '../services/terminal.service';

@Component({
    selector: 'app-terminal',
    template: '<div #terminalContainer class="terminal"></div>',
    styleUrls: ['./terminal.component.scss']
})
export class TerminalComponent implements AfterViewInit {
    @ViewChild('terminalContainer', { static: true }) terminalContainer!: ElementRef;
    private term!: Terminal;

    constructor(private terminalService: TerminalService) {}

    ngAfterViewInit(): void {
        this.term = new Terminal();
        this.term.open(this.terminalContainer.nativeElement);

        this.terminalService.getTerminalOutput().subscribe(data => {
            this.term.write(data);
        });
    }
}
