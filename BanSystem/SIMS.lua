--[[
    Kế hoạch dự án ASP.NET Core MVC

    1. Cấu trúc phân cấp Người dùng
    Gốc (Base): ApplicationUser
    Role 1: Administrator (Quản trị viên)
    Role 2: Faculty (Giảng viên/Cán bộ đào tạo)
    Role 3: Student (Sinh viên)


    2. Chi tiết quyền hạn và hành vi
    a. Gốc: USER (Tất cả mọi người)
    Đăng nhập/Đăng xuất: Truy cập vào hệ thống an toàn.
    Quản lý hồ sơ cá nhân: Thay đổi mật khẩu, cập nhật số điện thoại, ảnh đại diện.


    b. Role: ADMINISTRATOR
    Quản lý Khóa học (Course Management):
    Tạo mới, chỉnh sửa, xóa các môn học/khóa học.
    Thiết lập số tín chỉ, mã môn học.

    Quản lý Người dùng (User Management):
    Phê duyệt các đơn đăng ký nhập học của sinh viên.
    Tạo tài khoản và cấp quyền cho Giảng viên (Faculty).
    Khóa/Mở khóa tài khoản người dùng khi cần thiết.

    Quản lý Khoa/Ngành (Department Management):
    Tạo và quản lý các danh mục Khoa (vd: Khoa CNTT, Khoa Kinh tế).
    Báo cáo hệ thống: Xem thống kê số lượng sinh viên, tỉ lệ đăng ký môn học.


    c. Role: FACULTY
    Quản lý lớp học: Xem danh sách sinh viên đã đăng ký vào môn học mình phụ trách.

    Quản lý điểm số:
    Nhập điểm cho sinh viên sau mỗi kỳ thi.
    Chỉnh sửa điểm.


    d. Role: STUDENT 
    Đăng ký nhập học (Registration): Khai báo thông tin cá nhân ban đầu khi vào trường.
    Đăng ký môn học (Course Enrollment):
    Xem danh sách các môn học đang mở.
    Thực hiện đăng ký vào các lớp học phù hợp với chương trình.

    Quản lý kết quả học tập (Academic Records):
    Xem bảng điểm (Transcripts) theo kỳ hoặc toàn khóa.
    Theo dõi tiến độ học tập.

]]--

-- Demo cấu trúc dữ liệu hệ thống SIMS

SystemData = {
    ["Khoa: CNTT"] = {
        ["Môn: Lập trình cơ bản"] = {
            ["Khóa học: LTCB-SP20-01"] = {
                ["Thông tin môn học"] = {
                    ["Mã môn"] = "CS101",
                    ["Số tín chỉ"] = 3
                },

                ["Giảng viên"] = {
                    ["Mã GV"] = "GV001",
                    ["Họ tên"] = "Nguyễn Văn A",
                    ["Email"] = "a@school.edu"
                },

                ["Sinh viên"] = {
                    [1] = {
                        ["MSSV"] = "SE001",
                        ["Họ tên"] = "Nguyễn Minh",

                        ["Assignments"] = {
                            [1] = {
                                ["Tên"] = "Bài tập 1",
                                ["Điểm"] = 8.5
                            },
                            [2] = {
                                ["Tên"] = "Bài tập 2",
                                ["Điểm"] = 9.0
                            }
                        }
                    },

                    [2] = {
                        ["MSSV"] = "SE002",
                        ["Họ tên"] = "Trần Thị B",

                        ["Assignments"] = {
                            [1] = {
                                ["Tên"] = "Bài tập 1",
                                ["Điểm"] = 7.5
                            }
                        }
                    }
                }
            },

            ["Khóa học: LTCB-SP20-02"] = {}
        },

        ["Môn: Mạng máy tính"] = {
            ["Khóa học: MMT-SU20-01"] = {},
            ["Khóa học: MMT-FA20-01"] = {}
        },

        ["Môn: Cơ sở dữ liệu"] = {
            ["Khóa học: CSDL-SP20-01"] = {},
            ["Khóa học: CSDL-SP20-02"] = {}
        }
    },

    ["Khoa Kinh tế"] = {
        ["Kinh tế vi mô"] = {
            ["KTVM-SP20-01"] = {},
            ["KTVM-SP20-02"] = {}
        },

        ["Kinh tế vĩ mô"] = {
            ["KTVIMO-SP20-01"] = {},
            ["KTVIMO-SP20-02"] = {}
        },

        ["Kinh tế lượng"] = {
            ["KTL-SP20-01"] = {},
            ["KTL-SP20-02"] = {}
        }
    },

    ["Khoa Ngoại ngữ"] = {
        ["Tiếng Anh giao tiếp"] = {
            ["TAGT-SP20-01"] = {},
            ["TAGT-SP20-02"] = {}
        },

        ["Tiếng Nhật cơ bản"] = {
            ["TNCB-SP20-01"] = {}
        }
    },

    ["Khoa Điện - Điện tử"] = {
        ["Mạch điện"] = {
            ["MD-SP20-01"] = {}
        },

        ["Vi điều khiển"] = {
            ["VDK-SP20-01"] = {}
        }
    }
}


