// application
import AppLink from '../shared/AppLink';
import { ILink } from '../../interfaces/menus/link';

type FunctionComponentProps = {
    title: string;
    items?: ILink[];
};

function FooterLinks(props: FunctionComponentProps) {
    const { title, items = [] } = props;

    const linksList = items && items.map((item, index) => (
        <li key={index} className="footer-links__item">
            <AppLink href={item.url} className="footer-links__link">
                {item.title}
            </AppLink>
        </li>
    ));

    return (
        <div className="site-footer__widget footer-links">
            <h5 className="footer-links__title">{title}</h5>
            <ul className="footer-links__list">
                {linksList}
            </ul>
        </div>
    );
}

export default FooterLinks;
