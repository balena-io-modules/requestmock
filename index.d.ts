import * as request from 'request';

export interface ConfigurationOptions {
	Promise: PromiseConstructorLike;
}

export type MockCallback = (
	err: Error | null,
	headers: request.Headers,
	body: string,
) => void;
export type Handler = (opts: any, cb: MockCallback) => void;

export function configure(options: ConfigurationOptions): void;

export function register(
	method: string,
	url: string | RegExp,
	handler?: Handler,
): void;

export function deregister(
	method: string | null,
	url: string,
): void;

export function log(
	enabled: boolean,
): void;
