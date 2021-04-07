import { ILinkProps } from './link-props';

export interface ILink {
    title: string;
    url?: string | ILinkProps;
    props?: {
        target?: '_blank';
    };
}

export interface INestedLink extends ILink {
    children?: this[];
}
