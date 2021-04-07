// application
import AppLink from '../shared/AppLink';
import ArrowRoundedRight6x9Svg from '../../svg/arrow-rounded-right-6x9.svg';
import Megamenu from './Megamenu';
import Menu from './Menu';

// data stubs
import dataHeaderDepartments from '../../data/headerDepartments';

function DepartmentsLinks() {
    const linksList = dataHeaderDepartments.map((department, index) => {
        let arrow = null;
        let submenu = null;
        let itemClass = '';

        if (department.submenu) {
            arrow = <ArrowRoundedRight6x9Svg className="departments__link-arrow" />;
        }

        if (department.submenu && department.submenu.type === 'menu') {
            itemClass = 'departments__item--menu';
            submenu = (
                <div className="departments__menu">
                    <Menu items={department.submenu.menu} />
                </div>
            );
        }

        if (department.submenu && department.submenu.type === 'megamenu') {
            submenu = (
                <div className={`departments__megamenu departments__megamenu--${department.submenu.menu.size}`}>
                    <Megamenu menu={department.submenu.menu} location="department" />
                </div>
            );
        }

        return (
            <li key={index} className={`departments__item ${itemClass}`}>
                <AppLink href={department.url}>
                    {department.title}
                    {arrow}
                </AppLink>
                {submenu}
            </li>
        );
    });

    return (
        <ul className="departments__links">
            {linksList}
        </ul>
    );
}

export default DepartmentsLinks;
