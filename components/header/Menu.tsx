// react
import { Fragment, ReactNode } from 'react';

// third-party
import classNames from 'classnames';

// application
import AppLink from '../shared/AppLink';
import ArrowRoundedRight6x9Svg from '../../svg/arrow-rounded-right-6x9.svg';
import { IMenuItem } from '../../interfaces/menus/menu';

export type MenuLayout = 'classic' | 'topbar';

export interface MenuProps<T extends IMenuItem> {
    layout?: MenuLayout;
    withIcons?: boolean;
    items: T[];
    onClick?: (item: T) => void;
}

function Menu<T extends IMenuItem>(props: MenuProps<T>) {
    const {
        layout = 'classic',
        withIcons = false,
        items = [],
        onClick = () => {},
    } = props;

    const renderLink = (item: T, content: ReactNode) => {
        let link;

        if (item.url) {
            link = <AppLink href={item.url} onClick={() => onClick && onClick(item)}>{content}</AppLink>;
        } else {
            link = <button type="button" onClick={() => onClick && onClick(item)}>{content}</button>;
        }

        return link;
    };

    const itemsList = items.map((item, index) => {
        let arrow;
        let submenu;
        let icon;

        if (item.children && item.children.length) {
            arrow = <ArrowRoundedRight6x9Svg className="menu__arrow" />;
        }

        if (item.children && item.children.length) {
            submenu = (
                <div className="menu__submenu">
                    <Menu items={item.children} />
                </div>
            );
        }

        if (withIcons && item.icon) {
            icon = (
                <div className="menu__icon">
                    <img src={item.icon} alt="" />
                </div>
            );
        }

        return (
            <li key={index}>
                {renderLink(item, (
                    <Fragment>
                        {icon}
                        {item.title}
                        {arrow}
                    </Fragment>
                ))}
                {submenu}
            </li>
        );
    });

    const classes = classNames(`menu menu--layout--${layout}`, {
        'menu--with-icons': withIcons,
    });

    return (
        <ul className={classes}>
            {itemsList}
        </ul>
    );
}

export default Menu;
