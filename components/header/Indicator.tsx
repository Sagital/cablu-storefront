// react
import {
    ReactNode,
    MouseEvent as ReactMouseEvent,
    createRef,
    Component,
} from 'react';

// third-party
import classNames from 'classnames';

// application
import AppLink from '../shared/AppLink';
import { ILinkProps } from '../../interfaces/menus/link-props';

export interface IndicatorProps {
    value?: number;
    dropdown?: ReactNode;
    icon?: ReactNode;
    url?: string | ILinkProps;
    className?: string;
    onClick?: (event: ReactMouseEvent<HTMLAnchorElement | HTMLButtonElement>) => void;
    onOpen?: () => void;
    onClose?: () => void;
}

export interface IndicatorState {
    open: boolean;
}

class Indicator extends Component<IndicatorProps, IndicatorState> {
    wrapperRef = createRef<HTMLDivElement>();

    constructor(props: IndicatorProps) {
        super(props);

        this.state = {
            open: false,
        };
    }

    componentDidMount() {
        document.addEventListener('mousedown', this.handleOutsideClick);
    }

    componentDidUpdate(prevProps: IndicatorProps, prevState: IndicatorState) {
        const { open } = this.state;
        const { onOpen, onClose } = this.props;

        if (open !== prevState.open) {
            if (open && onOpen) {
                onOpen();
            }
            if (!open && onClose) {
                onClose();
            }
        }
    }

    componentWillUnmount() {
        document.removeEventListener('mousedown', this.handleOutsideClick);
    }

    handleOutsideClick = (event: MouseEvent) => {
        const { open } = this.state;

        if (this.wrapperRef.current && !this.wrapperRef.current.contains(event.target as HTMLElement) && open) {
            this.close();
        }
    };

    handleButtonClick = (event: ReactMouseEvent<HTMLAnchorElement | HTMLButtonElement>) => {
        const { onClick, dropdown } = this.props;

        if (dropdown) {
            event.preventDefault();
        }

        this.toggle();

        if (onClick) {
            onClick(event);
        }
    };

    toggle() {
        this.setState((state) => ({
            open: !state.open,
        }));
    }

    open() {
        this.setState(() => ({
            open: true,
        }));
    }

    close() {
        this.setState(() => ({
            open: false,
        }));
    }

    render() {
        const { open } = this.state;
        const { url, className, icon } = this.props;
        const { value, dropdown } = this.props;
        let buttonElement;
        let dropdownElement;

        const title = (
            <span className="indicator__area">
                {icon}
                {value !== undefined && <span className="indicator__value">{value}</span>}
            </span>
        );

        if (url) {
            buttonElement = (
                <AppLink href={url} className="indicator__button" onClick={this.handleButtonClick}>
                    {title}
                </AppLink>
            );
        } else {
            buttonElement = (
                <button type="button" className="indicator__button" onClick={this.handleButtonClick}>
                    {title}
                </button>
            );
        }

        if (dropdown) {
            dropdownElement = (
                <div className="indicator__dropdown">
                    {dropdown}
                </div>
            );
        }

        const classes = classNames(`indicator indicator--trigger--click ${className}`, {
            'indicator--opened': open,
        });

        return (
            <div className={classes} ref={this.wrapperRef}>
                {buttonElement}
                {dropdownElement}
            </div>
        );
    }
}

export default Indicator;
