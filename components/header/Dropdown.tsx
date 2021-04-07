// react
import {
    ReactNode,
    useEffect,
    useRef,
    useState,
} from 'react';

// third-party
import classNames from 'classnames';

// application
import ArrowRoundedDown7x5Svg from '../../svg/arrow-rounded-down-7x5.svg';
import Menu from './Menu';
import { IMenuItem } from '../../interfaces/menus/menu';

export interface DropdownProps<T extends IMenuItem> {
    title: ReactNode;
    items: T[];
    withIcons?: boolean;
    onClick?: (item: T) => void;
}

function Dropdown<T extends IMenuItem>(props: DropdownProps<T>) {
    const {
        title,
        items,
        withIcons = false,
        onClick,
    } = props;
    const [open, setOpen] = useState(false);
    const wrapperRef = useRef<HTMLDivElement>(null);

    const handleButtonClick = () => {
        setOpen((prev) => !prev);
    };

    const handleItemClick = (item: T) => {
        setOpen(false);

        if (onClick) {
            onClick(item);
        }
    };

    useEffect(() => {
        const handleOutsideClick = (event: MouseEvent) => {
            if (wrapperRef.current && !wrapperRef.current.contains(event.target as HTMLElement)) {
                setOpen(false);
            }
        };

        document.addEventListener('mousedown', handleOutsideClick);

        return () => document.removeEventListener('mousedown', handleOutsideClick);
    }, [wrapperRef, setOpen]);

    const classes = classNames('topbar-dropdown', {
        'topbar-dropdown--opened': open,
    });

    return (
        <div className={classes} ref={wrapperRef}>
            <button className="topbar-dropdown__btn" type="button" onClick={handleButtonClick}>
                {title}
                <ArrowRoundedDown7x5Svg />
            </button>

            <div className="topbar-dropdown__body">
                <Menu
                    layout="topbar"
                    withIcons={withIcons}
                    items={items}
                    onClick={handleItemClick}
                />
            </div>
        </div>
    );
}

export default Dropdown;
