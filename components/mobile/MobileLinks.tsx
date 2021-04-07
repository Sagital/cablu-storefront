// application
import AppLink from '../shared/AppLink';
import ArrowRoundedDown12x7Svg from '../../svg/arrow-rounded-down-12x7.svg';
import Collapse, { CollapseRenderFn } from '../shared/Collapse';
import { IMobileMenuLink } from '../../interfaces/menus/mobile-menu';

export type RenderItemFn = CollapseRenderFn<HTMLDivElement, HTMLDivElement>;

export interface MobileLinksProps {
    links?: IMobileMenuLink[];
    level?: number;
    onItemClick?: (item: IMobileMenuLink) => void;
}

function MobileLinks(props: MobileLinksProps) {
    const { links = [], level = 0, onItemClick } = props;

    const handleItemClick = (item: IMobileMenuLink) => {
        if (onItemClick) {
            onItemClick(item);
        }
    };

    const linksList = links.map((link, index) => {
        let item;

        if (link.type === 'link' || link.type === 'button') {
            const renderItem: RenderItemFn = ({ toggle, setItemRef, setContentRef }) => {
                let arrow;
                let subLinks;
                let linkOrButton;

                if (link.children && link.children.length > 0) {
                    arrow = (
                        <button className="mobile-links__item-toggle" type="button" onClick={toggle}>
                            <ArrowRoundedDown12x7Svg className="mobile-links__item-arrow" />
                        </button>
                    );

                    subLinks = (
                        <div className="mobile-links__item-sub-links" ref={setContentRef}>
                            <MobileLinks
                                links={link.children}
                                level={level + 1}
                                onItemClick={onItemClick}
                            />
                        </div>
                    );
                }

                if (link.type === 'link') {
                    linkOrButton = (
                        <AppLink
                            href={link.url}
                            className="mobile-links__item-link"
                            onClick={() => handleItemClick(link)}
                        >
                            {link.title}
                        </AppLink>
                    );
                } else {
                    linkOrButton = (
                        <button
                            type="button"
                            className="mobile-links__item-link"
                            onClick={() => handleItemClick(link)}
                        >
                            {link.title}
                        </button>
                    );
                }

                return (
                    <div className="mobile-links__item" ref={setItemRef}>
                        <div className="mobile-links__item-title">
                            {linkOrButton}
                            {arrow}
                        </div>
                        {subLinks}
                    </div>
                );
            };

            item = <Collapse toggleClass="mobile-links__item--open" render={renderItem} />;
        } else if (link.type === 'divider') {
            item = <div className="mobile-links__divider" />;
        }

        return <li key={index}>{item}</li>;
    });

    return (
        <ul className={`mobile-links mobile-links--level--${level}`}>
            {linksList}
        </ul>
    );
}

export default MobileLinks;
