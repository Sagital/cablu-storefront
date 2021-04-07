// third-party
import classNames from 'classnames';

// application
import AppLink from '../shared/AppLink';
import { INestedLink } from '../../interfaces/menus/link';

export interface MegamenuLinksProps {
    links: INestedLink[];
    depth?: number;
}

function MegamenuLinks(props: MegamenuLinksProps) {
    const { links, depth = 0 } = props;

    const linksList = links.map((link, index) => {
        let title = null;
        let subLinks = null;

        if (link.title) {
            title = <AppLink href={link.url}>{link.title}</AppLink>;
        }

        if (link.children && link.children.length) {
            subLinks = <MegamenuLinks links={link.children} depth={depth + 1} />;
        }

        const classes = classNames('megamenu__item', {
            'megamenu__item--with-submenu': subLinks,
        });

        return (
            <li key={index} className={classes}>
                {title}
                {subLinks}
            </li>
        );
    });

    return (
        <ul className={`megamenu__links megamenu__links--level--${depth}`}>
            {linksList}
        </ul>
    );
}

export default MegamenuLinks;
