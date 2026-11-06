# ==============================================================================
# BÀI 3: TÌM PHẦN TỬ LỚN THỨ NHÌ TRONG MẢNG 10 PHẦN TỬ VÀ IN TẤT CẢ CÁC CHỈ SỐ
# (LAB 2: BRANCHES AND PROCEDURES - CÓ BẮT NGOẠI LỆ TOÀN DIỆN & TEST SUITE)
# ==============================================================================
#
# YÊU CẦU ĐỀ BÀI (LAB 2 - EXERCISE 3):
# - Nhập mảng gồm 10 số nguyên từ bàn phím.
# - Câu nhắc nhập cho từng phần tử: "Please insert a element: ".
# - Tìm giá trị lớn thứ nhì (second largest element) trong mảng.
# - Tìm và in ra TẤT CẢ các chỉ số (indexes, từ 0 đến 9) chứa giá trị này.
# - Định dạng kết quả mẫu:
#     Nếu mảng là: 1, 2, 7, -7, 3, 7, 4, 6, 8, 7
#     Kết quả in ra: "Second largest value is 7, found in index 2, 5, 9."
#
# ==============================================================================
# I. PHÂN TÍCH NGOẠI LỆ TOÀN DIỆN & CÁC TRƯỜNG HỢP BIÊN (EDGE CASES):
# ==============================================================================
# 1. Ngoại lệ cả 10 phần tử bằng nhau (All Elements Equal):
#    - Ví dụ: `[5, 5, 5, 5, 5, 5, 5, 5, 5, 5]`.
#    - Khi đó không tồn tại phần tử nào nhỏ hơn max1 => không tồn tại giá trị lớn thứ nhì!
#    - Giải pháp: Khởi tạo cờ hiệu `has_max2 = 0`. Nếu duyệt hết Lượt 2 mà cờ vẫn bằng 0,
#      chương trình nhận diện và in lỗi: "Error: All elements are equal, second largest value does not exist!\n"
#      sau đó dừng an toàn, không in kết quả sai.
#
# 2. Ngoại lệ mảng chứa toàn số âm (All Negative Elements):
#    - Ví dụ: `[-10, -5, -20, -5, -30, -5, -40, -50, -60, -70]`.
#    - Số lớn nhất là max1 = -5. Số lớn thứ nhì phải là max2 = -10 (tại index 0).
#    - Giải pháp: Không khởi tạo `max2 = 0` (vì 0 > mọi số âm sẽ gây sai). Chỉ khi tìm thấy
#      số đầu tiên < max1 thì mới gán mốc cho max2 và bật cờ `has_max2 = 1`.
#
# 3. Trường hợp max1 xuất hiện nhiều lần (Multiple Maximums):
#    - Ví dụ: `[99, 99, 99, 50, ...]`. Vì Lượt 2 chỉ xét `arr[i] < max1`, các số 99 bị bỏ qua,
#      đảm bảo tìm chính xác giá trị 50 là max2.
#
# 4. Trường hợp max2 xuất hiện 1 lần hay nhiều lần:
#    - Chương trình quản lý biến đếm in `$s5` để định dạng dấu phẩy tiếng Anh chuẩn xác:
#      Nếu 1 chỉ số: `found in index 8.`
#      Nếu nhiều chỉ số: `found in index 2, 5, 9.`
#
# ==============================================================================
# II. BẢNG BỘ TEST CASE KIỂM THỬ TOÀN DIỆN (TEST SUITE):
# ==============================================================================
# +-------+---------------------------+---------------------------------------+-------------------------------------------------------------+
# | STT   | Mục đích kiểm thử         | Dữ liệu vào (10 phần tử)              | Kết quả mong đợi (Expected Output)                          |
# +-------+---------------------------+---------------------------------------+-------------------------------------------------------------+
# | TC01  | Đề bài (max2 lặp 3 lần)   | 1, 2, 7, -7, 3, 7, 4, 6, 8, 7         | Second largest value is 7, found in index 2, 5, 9.          |
# | TC02  | max2 xuất hiện 1 lần      | 10, 20, 30, 40, 50, 60, 70, 80, 90, 100| Second largest value is 90, found in index 8.             |
# | TC03  | max1 lặp lại nhiều lần    | 99, 99, 99, 50, 20, 10, 50, 5, 2, 1   | Second largest value is 50, found in index 3, 6.            |
# | TC04  | Mảng chứa toàn số âm      | -10, -5, -20, -5, -30, -5, -40, -50...| Second largest value is -10, found in index 0.              |
# | TC05  | Ngoại lệ 10 số bằng nhau  | 5, 5, 5, 5, 5, 5, 5, 5, 5, 5          | Error: All elements are equal, second largest...            |
# +-------+---------------------------+---------------------------------------+-------------------------------------------------------------+
#
# ==============================================================================
# III. CODE TƯƠNG ĐƯƠNG TRONG C:
# ==============================================================================
#   #include <stdio.h>
#   int main() {
#       int arr[10];
#       for (int i = 0; i < 10; i++) {
#           printf("Please insert a element: ");
#           scanf("%d", &arr[i]);
#       }
#       int max1 = arr[0];
#       for (int i = 1; i < 10; i++) {
#           if (arr[i] > max1) max1 = arr[i];
#       }
#       int has_max2 = 0, max2;
#       for (int i = 0; i < 10; i++) {
#           if (arr[i] < max1) {
#               if (!has_max2 || arr[i] > max2) {
#                   max2 = arr[i];
#                   has_max2 = 1;
#               }
#           }
#       }
#       if (!has_max2) {
#           printf("Error: All elements are equal, second largest value does not exist!\n");
#           return 1;
#       }
#       printf("Second largest value is %d, found in index ", max2);
#       int count = 0;
#       for (int i = 0; i < 10; i++) {
#           if (arr[i] == max2) {
#               if (count > 0) printf(", ");
#               printf("%d", i);
#               count++;
#           }
#       }
#       printf(".\n");
#       return 0;
#   }
#
# ==============================================================================
# IV. QUY ƯỚC THANH GHI:
# ==============================================================================
#   - $s0 : Địa chỉ cơ sở của mảng array trong RAM
#   - $s1 : Số phần tử của mảng (hằng số N = 10)
#   - $s2 : Giá trị lớn nhất tuyệt đối (max1)
#   - $s3 : Giá trị lớn thứ nhì (max2)
#   - $s4 : Cờ hiệu has_max2 (0: chưa tìm thấy số nào < max1, 1: đã tìm thấy)
#   - $s5 : Đếm số lượng chỉ số đã in (để in dấu phẩy ", " chuẩn xác)
#   - $t0 : Biến đếm vòng lặp i (chạy từ 0 đến 9)
#   - $t1 : Địa chỉ ô nhớ của phần tử arr[i] trong RAM
#   - $t2 : Giá trị của phần tử hiện tại arr[i]
# ==============================================================================

.data
    .align 2
    array:          .space 40               # Cấp phát 40 bytes trong RAM cho 10 phần tử (10 * 4 bytes)
    prompt:         .asciiz "Please insert a element: "
    msg_part1:      .asciiz "Second largest value is "
    msg_part2:      .asciiz ", found in index "
    comma_space:    .asciiz ", "
    dot_newline:    .asciiz ".\n"
    err_equal:      .asciiz "Error: All elements are equal, second largest value does not exist!\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # BƯỚC 1: Khởi tạo các thanh ghi ban đầu
    # --------------------------------------------------------------------------
    la   $s0, array             # Nạp địa chỉ bắt đầu của mảng array vào thanh ghi $s0
    li   $s1, 10                # Nạp số lượng phần tử N = 10 vào thanh ghi $s1
    li   $t0, 0                 # Khởi tạo biến đếm chỉ số vòng lặp i = 0 vào thanh ghi $t0

    # --------------------------------------------------------------------------
    # BƯỚC 2: Vòng lặp nhập 10 phần tử từ bàn phím
    # --------------------------------------------------------------------------
input_loop:
    bge  $t0, $s1, find_max1_start # Nếu i >= 10 (đã nhập đủ 10 số) thì chuyển sang tìm max1

    # In câu nhắc: "Please insert a element: "
    li   $v0, 4                 # Syscall 4: Chức năng in chuỗi ký tự (print_string)
    la   $a0, prompt            # Nạp địa chỉ chuỗi prompt vào $a0
    syscall                     # Thực hiện syscall in câu nhắc

    # Đọc số nguyên từ bàn phím
    li   $v0, 5                 # Syscall 5: Chức năng đọc số nguyên từ bàn phím (read_int)
    syscall                     # Chờ người dùng nhập số và nhấn Enter, giá trị lưu vào $v0
    move $t2, $v0               # Chuyển số vừa nhập từ $v0 sang thanh ghi tạm $t2

    # Lưu giá trị vào mảng: arr[i] = $t2
    sll  $t1, $t0, 2            # $t1 = i * 4 (tính độ lệch byte của phần tử thứ i)
    add  $t1, $s0, $t1          # $t1 = địa chỉ cơ sở + độ lệch byte = &arr[i]
    sw   $t2, 0($t1)            # Ghi giá trị $t2 vào ô nhớ RAM tại địa chỉ $t1

    addi $t0, $t0, 1            # i = i + 1 (tăng biến đếm lên 1)
    j    input_loop             # Nhảy lặp lại bước nhập số tiếp theo

    # --------------------------------------------------------------------------
    # BƯỚC 3 (LƯỢT 1): Tìm giá trị lớn nhất tuyệt đối (max1)
    # --------------------------------------------------------------------------
find_max1_start:
    lw   $s2, 0($s0)            # Khởi tạo max1 = arr[0] (nạp phần tử đầu tiên vào $s2)
    li   $t0, 1                 # Bắt đầu duyệt so sánh từ phần tử thứ 1 (i = 1)

max1_loop:
    bge  $t0, $s1, find_max2_start # Nếu duyệt hết mảng (i >= 10) thì chuyển sang tìm max2

    sll  $t1, $t0, 2            # $t1 = i * 4 (tính độ lệch byte)
    add  $t1, $s0, $t1          # $t1 = &arr[i]
    lw   $t2, 0($t1)            # Đọc giá trị arr[i] từ RAM nạp vào $t2

    ble  $t2, $s2, skip_max1    # Nếu arr[i] <= max1 thì không cập nhật, nhảy qua
    move $s2, $t2               # Nếu arr[i] > max1 thì cập nhật max1 = arr[i]

skip_max1:
    addi $t0, $t0, 1            # i = i + 1 (chuyển sang phần tử tiếp theo)
    j    max1_loop              # Lặp lại bước tìm max1

    # --------------------------------------------------------------------------
    # BƯỚC 4 (LƯỢT 2): Tìm giá trị lớn thứ nhì (max2 < max1)
    # --------------------------------------------------------------------------
find_max2_start:
    li   $s4, 0                 # Khởi tạo cờ has_max2 = 0 (chưa tìm thấy số nào < max1)
    li   $t0, 0                 # Đặt lại chỉ số i = 0 để duyệt lại mảng từ đầu

max2_loop:
    bge  $t0, $s1, check_valid_max2 # Nếu duyệt xong 10 phần tử thì kiểm tra hợp lệ của max2

    sll  $t1, $t0, 2            # $t1 = i * 4 (tính độ lệch byte)
    add  $t1, $s0, $t1          # $t1 = &arr[i]
    lw   $t2, 0($t1)            # Đọc giá trị arr[i] từ RAM nạp vào $t2

    # Chỉ xét những phần tử thực sự nhỏ hơn max1 (arr[i] < max1)
    bge  $t2, $s2, skip_max2    # Nếu arr[i] >= max1 thì bỏ qua không xét

    # Nếu chưa khởi tạo max2 (has_max2 == 0) -> Gán luôn max2 = arr[i] làm mốc đầu tiên
    beqz $s4, init_first_max2   # Nếu cờ $s4 == 0 thì nhảy tới init_first_max2

    # Nếu đã có mốc max2, kiểm tra xem arr[i] có lớn hơn max2 hiện tại không
    ble  $t2, $s3, skip_max2    # Nếu arr[i] <= max2 thì không cập nhật, bỏ qua
    move $s3, $t2               # Nếu arr[i] > max2 thì cập nhật max2 = arr[i]
    j    skip_max2              # Nhảy qua phần khởi tạo

init_first_max2:
    move $s3, $t2               # Gán giá trị đầu tiên nhỏ hơn max1 làm mốc cho max2
    li   $s4, 1                 # Bật cờ has_max2 = 1 (đã tìm thấy ít nhất 1 số < max1)

skip_max2:
    addi $t0, $t0, 1            # i = i + 1 (chuyển sang phần tử tiếp theo)
    j    max2_loop              # Lặp lại bước tìm max2

    # --------------------------------------------------------------------------
    # BƯỚC 5: BẮT NGOẠI LỆ - Kiểm tra nếu cả 10 số trong mảng đều bằng nhau
    # --------------------------------------------------------------------------
check_valid_max2:
    beqz $s4, error_all_equal   # Nếu cờ has_max2 vẫn bằng 0 (không có số nào < max1) => báo lỗi

    # --------------------------------------------------------------------------
    # BƯỚC 6 (LƯỢT 3): In kết quả và duyệt in tất cả các chỉ số của max2
    # --------------------------------------------------------------------------
    # In chuỗi "Second largest value is "
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, msg_part1         # Nạp địa chỉ chuỗi msg_part1 vào $a0
    syscall                     # Thực hiện in chuỗi

    # In giá trị số lớn thứ nhì (max2)
    li   $v0, 1                 # Syscall 1: In số nguyên
    move $a0, $s3               # Nạp giá trị max2 ($s3) vào $a0 để in
    syscall                     # Thực hiện in số max2

    # In chuỗi ", found in index "
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, msg_part2         # Nạp địa chỉ chuỗi msg_part2 vào $a0
    syscall                     # Thực hiện in chuỗi

    li   $s5, 0                 # Khởi tạo biến đếm số lượng chỉ số đã in = 0
    li   $t0, 0                 # Đặt lại biến đếm i = 0 để duyệt mảng lần cuối

print_indices_loop:
    bge  $t0, $s1, print_finish # Nếu đã duyệt hết 10 phần tử thì hoàn tất in

    sll  $t1, $t0, 2            # $t1 = i * 4 (tính độ lệch byte)
    add  $t1, $s0, $t1          # $t1 = &arr[i]
    lw   $t2, 0($t1)            # Đọc giá trị arr[i] từ RAM nạp vào $t2

    bne  $t2, $s3, skip_print   # Nếu arr[i] != max2 thì không phải số cần tìm, bỏ qua

    # Kiểm tra xem đây có phải chỉ số đầu tiên được in không
    beqz $s5, print_idx_number  # Nếu $s5 == 0 (chỉ số đầu tiên) thì in trực tiếp không cần dấu phẩy
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, comma_space       # Nạp địa chỉ chuỗi dấu phẩy và khoảng trắng ", " vào $a0
    syscall                     # Thực hiện in dấu phẩy ", "

print_idx_number:
    li   $v0, 1                 # Syscall 1: In số nguyên
    move $a0, $t0               # Nạp giá trị chỉ số i ($t0) vào $a0 để in
    syscall                     # Thực hiện in chỉ số i
    addi $s5, $s5, 1            # Tăng biến đếm số lượng chỉ số đã in lên 1

skip_print:
    addi $t0, $t0, 1            # i = i + 1 (chuyển sang phần tử tiếp theo)
    j    print_indices_loop     # Lặp lại bước in cho phần tử kế tiếp

print_finish:
    # In dấu chấm và xuống dòng ".\n"
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, dot_newline       # Nạp địa chỉ chuỗi ".\n" vào $a0
    syscall                     # Thực hiện in dấu chấm và ký tự xuống dòng

    # Kết thúc chương trình bình thường
    li   $v0, 10                # Syscall 10: Thoát chương trình (exit)
    syscall                     # Gọi hệ điều hành dừng thực thi an toàn

# ------------------------------------------------------------------------------
# XỬ LÝ NGOẠI LỆ: Khi tất cả 10 phần tử có giá trị bằng nhau
# ------------------------------------------------------------------------------
error_all_equal:
    li   $v0, 4                 # Syscall 4: In chuỗi ký tự
    la   $a0, err_equal         # Nạp địa chỉ thông báo lỗi vào $a0
    syscall                     # Thực hiện in thông báo lỗi

    li   $v0, 10                # Syscall 10: Thoát chương trình
    syscall                     # Dừng chương trình ngay lập tức
