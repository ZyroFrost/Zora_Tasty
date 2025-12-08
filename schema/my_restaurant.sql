CREATE TABLE Customers(
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(100) NOT NULL,
	phone VARCHAR(50) UNIQUE,
	email VARCHAR(50) UNIQUE,
	birthdate DATE,
	loyalty_points INT DEFAULT 0 CHECK (loyalty_points >= 0), -- điểm tích lũy thành viên - Customer loyalty points
	member_since TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE Staff_Roles(
	staffrole_id SERIAL PRIMARY KEY,
	staffrole_name VARCHAR(100) NOT NULL UNIQUE,
	description TEXT,
	status VARCHAR(20) NOT NULL DEFAULT 'active'
    	CHECK (status IN ('active', 'inactive')),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Staffs(
	staff_id SERIAL PRIMARY KEY,
	staff_name VARCHAR(100) NOT NULL,
	phone VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(50) UNIQUE,
	birthdate DATE NOT NULL,
	address VARCHAR(255) NOT NULL,
	status VARCHAR(20) DEFAULT 'active' 
        CHECK (status IN ('active', 'inactive')),
	staffrole_id INT REFERENCES Staff_Roles(staffrole_id) ON DELETE SET NULL, 
	-- Liên kết bảng staffrole, đồng thời nếu xóa role cũng ko mất ID nhân viên - If the role is deleted, the ID of the staff is not deleted
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- bảng ca trực
CREATE TABLE Staff_Shifts(
    shift_id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES Staffs(staff_id),
    shift_date DATE NOT NULL,
    shift_type VARCHAR(20) 
		CHECK (shift_type IN ('morning', 'afternoon', 'evening', 'night')),
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    status VARCHAR(20) DEFAULT 'scheduled' 
        CHECK (status IN ('scheduled', 'checked_in', 'checked_out', 'absent')),
    note TEXT,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE Tables(
	table_id SERIAL PRIMARY KEY,
	table_name VARCHAR(20) NOT NULL UNIQUE,
	capacity INT NOT NULL DEFAULT 2 CHECK (capacity > 0),
	status VARCHAR(20) NOT NULL DEFAULT 'available'
		CHECK (status IN ('available', 'reserved', 'occupied')),
		-- status default has 3 types: bàn trống, đã đặt trước, đang có khách
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Bookings(
	booking_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES Customers(customer_id),
	booking_name VARCHAR(100) NOT NULL, -- name of customer
	phone VARCHAR(50) NOT NULL, -- phone of customer
	booking_time TIMESTAMP NOT NULL, -- time when customer book
	table_id INT NULL REFERENCES Tables(table_id), -- table that customer book, NULL which mean for combine table
	num_people INT DEFAULT 2, -- default number of people is 2
	status VARCHAR(20) NOT NULL DEFAULT 'reserved'
		CHECK (status IN ('reserved', 'cancelled', 'completed', 'no_show')),
		-- status default has 4 types: đã đặt trước, đã hủy, khách đã nhận bàn, khách ko tới
	note TEXT, -- note of customer (optional, birthday, special request,...)
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- This table is for combine tables when customer needs bigger table
CREATE TABLE Booking_Combine_Tables( 
    booking_id INT REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    table_id INT REFERENCES Tables(table_id) ON DELETE CASCADE,
	-- xóa bảng cha sẽ xóa luôn bảng con, vì đây là bàn ghép tạm, 
	-- nếu xóa đặt bàn thì xóa luôn ghép bàn
    PRIMARY KEY (booking_id, table_id)
);

-- bảng liên kết với các ứng dụng đặt đồ ăn ngoài
CREATE TABLE Delivery_Partners(
	partner_id SERIAL PRIMARY KEY,
	partner_name VARCHAR(50) NOT NULL UNIQUE, -- GrabFood, ShopeeFood, Baemin,...
	api_endpoint VARCHAR(255), -- (tuỳ chọn) URL hoặc thông tin tích hợp - optional (API endpoint of delivery partner)
	contact_info VARCHAR(100),
	active BOOLEAN NOT NULL DEFAULT TRUE, -- -- bật/tắt đối tác - active/inactive partner
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categories(
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE, -- type of food (chicken, beef, rice, drink,...)
	description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'inactive')),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Ingredients(
	ingredient_id SERIAL PRIMARY KEY,
	ingredient_name VARCHAR(50) NOT NULL UNIQUE,
	unit VARCHAR(20) NOT NULL, -- đơn vị: gram, ml, piece
	unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost >= 0),
	stock_quantity DECIMAL(10,2) DEFAULT 0 CHECK (stock_quantity >= 0), --
    reorder_level DECIMAL(10,2) DEFAULT 10, -- mức độ cảnh báo cần nhập thêm hàng - threshold of stock when need to reorder
    status VARCHAR(20) NOT NULL DEFAULT 'available'
        CHECK (status IN ('available', 'unavailable', 'out_of_stock')),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- bảng các món ăn chính (menu)
CREATE TABLE Menu_Items( 
	item_id SERIAL PRIMARY KEY,
	item_name VARCHAR(100) NOT NULL UNIQUE,
	category_id INT NOT NULL REFERENCES Categories(category_id),
	sell_price DECIMAL(10,2) NOT NULL CHECK (sell_price > 0),
	is_signature BOOLEAN DEFAULT FALSE, -- có phải là món đặc trưng của quán ko - is it a signature dish of the restaurant
	status VARCHAR(20) NOT NULL DEFAULT 'available'
        CHECK (status IN ('available', 'unavailable', 'out_of_stock')),
    description TEXT,
	image_url VARCHAR(255), -- ảnh mô tả món ăn
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- định lượng (công thức món ăn) - Recipe
CREATE TABLE Menu_Ingredients(
    item_id INT REFERENCES Menu_Items(item_id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES Ingredients(ingredient_id),
    quantity_used DECIMAL(10,2) NOT NULL CHECK (quantity_used > 0),
    PRIMARY KEY (item_id, ingredient_id)
);

-- Suppliers – Nhà cung cấp
CREATE TABLE Suppliers(
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    contact_name VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(100),
    address VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'inactive')),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Purchase_Orders – Đơn nhập hàng
CREATE TABLE Purchase_Orders(
    purchase_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES Suppliers(supplier_id),
    staff_id INT REFERENCES Staffs(staff_id), -- người tạo đơn nhập - staff id of staff who created the purchase order
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_cost DECIMAL(10,2) DEFAULT 0 CHECK (total_cost >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'ordered'
        CHECK (status IN ('ordered', 'received', 'cancelled')),
	purchase_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    updated_at TIMESTAMP DEFAULT NULL
);

-- Purchase_Details – Chi tiết nhập hàng
CREATE TABLE Purchase_Details(
    purchase_detail_id SERIAL PRIMARY KEY,
    purchase_id INT REFERENCES Purchase_Orders(purchase_id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES Ingredients(ingredient_id),
    quantity DECIMAL(10,2) NOT NULL CHECK (quantity > 0),
    unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost >= 0),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_cost) STORED,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE Promotions(
	promo_id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE,
    promo_name VARCHAR(100) NOT NULL,
    description TEXT,
    promo_type VARCHAR(20) NOT NULL DEFAULT 'order'
        CHECK (promo_type IN ('order', 'item')),
    discount_type VARCHAR(20) NOT NULL
        CHECK (discount_type IN ('percent', 'fixed')),
    discount_value DECIMAL(10,2) NOT NULL CHECK (discount_value > 0),
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (start_date <= end_date),
    usage_limit INT DEFAULT NULL, -- giới hạn người dc khuyến mãi, NULL = không giới hạn
    used_count INT DEFAULT 0 CHECK (used_count >= 0), -- check bao nhiêu người đã dùng mã km
    status VARCHAR(20) DEFAULT 'active'
    	CHECK (status IN ('active', 'expired', 'upcoming', 'depleted')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- giảm giá dựa trên món ăn
CREATE TABLE Promotion_Items(
    promo_id INT REFERENCES Promotions(promo_id) ON DELETE CASCADE,
    item_id INT REFERENCES Menu_Items(item_id) ON DELETE CASCADE,
    discount_value DECIMAL(10,2) CHECK (discount_value >= 0),
    PRIMARY KEY (promo_id, item_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders(
	order_id SERIAL PRIMARY KEY,
	staff_id INT REFERENCES Staffs(staff_id),
	customer_id INT REFERENCES Customers(customer_id),
	partner_id INT REFERENCES Delivery_Partners(partner_id),
	booking_id INT REFERENCES Bookings(booking_id),
	order_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	total_amount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
	status VARCHAR(20) NOT NULL DEFAULT 'pending'
		CHECK (status IN ('pending', 'preparing', 'delivering', 'completed', 'cancelled')),
	delivery_address VARCHAR (255),
	note TEXT,
    updated_at TIMESTAMP DEFAULT NULL
);

-- chi tiết món trong đơn
CREATE TABLE Order_Details(
	order_detail_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES Orders(order_id) ON DELETE CASCADE,
	item_id INT NOT NULL REFERENCES Menu_Items(item_id),
	quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
	price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * price) STORED,
	-- tự động tính thành tiền của từng món trong đơn hàng
    note TEXT,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

-- bảng order giảm giá
CREATE TABLE Order_Promotions(
	order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    promo_id INT REFERENCES Promotions(promo_id) ON DELETE CASCADE,
    discount_amount DECIMAL(10,2) NOT NULL CHECK (discount_amount >= 0),
    PRIMARY KEY (order_id, promo_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- bảng dùng để gộp bàn khi khách cần bàn lớn
CREATE TABLE Order_Combine_Tables( 
	order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
	table_id INT REFERENCES Tables(table_id) ON DELETE CASCADE,
	PRIMARY KEY (order_id, table_id)
);

CREATE TABLE Payments(
	payment_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES Orders(order_id) ON DELETE CASCADE,
	-- Bỏ unique để chia nhỏ thanh toán (cash+card)
	payment_method VARCHAR(50) NOT NULL,
	amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
	payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);