
C:\Users\Phuc\Downloads\chall:     file format elf64-x86-64


Disassembly of section .text:

0000000000402a1d <.text+0x191d>:
  402a1d:	55                   	push   rbp
  402a1e:	48 89 e5             	mov    rbp,rsp
  402a21:	48 83 ec 30          	sub    rsp,0x30
  402a25:	48 89 7d d8          	mov    QWORD PTR [rbp-0x28],rdi
  402a29:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  402a2d:	48 89 c7             	mov    rdi,rax
  402a30:	e8 83 e6 ff ff       	call   0x4010b8
  402a35:	48 83 f8 1d          	cmp    rax,0x1d
  402a39:	74 07                	je     0x402a42
  402a3b:	b8 00 00 00 00       	mov    eax,0x0
  402a40:	eb 73                	jmp    0x402ab5
  402a42:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  402a46:	ba 07 00 00 00       	mov    edx,0x7
  402a4b:	be 8c bc 47 00       	mov    esi,0x47bc8c
  402a50:	48 89 c7             	mov    rdi,rax
  402a53:	e8 10 e6 ff ff       	call   0x401068
  402a58:	85 c0                	test   eax,eax
  402a5a:	74 07                	je     0x402a63
  402a5c:	b8 00 00 00 00       	mov    eax,0x0
  402a61:	eb 52                	jmp    0x402ab5
  402a63:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  402a67:	48 83 c0 1c          	add    rax,0x1c
  402a6b:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  402a6e:	3c 7d                	cmp    al,0x7d
  402a70:	74 07                	je     0x402a79
  402a72:	b8 00 00 00 00       	mov    eax,0x0
  402a77:	eb 3c                	jmp    0x402ab5
  402a79:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
  402a7d:	48 8d 48 07          	lea    rcx,[rax+0x7]
  402a81:	48 8d 45 e0          	lea    rax,[rbp-0x20]
  402a85:	ba 15 00 00 00       	mov    edx,0x15
  402a8a:	48 89 ce             	mov    rsi,rcx
  402a8d:	48 89 c7             	mov    rdi,rax
  402a90:	e8 9b e5 ff ff       	call   0x401030
  402a95:	48 8d 45 e0          	lea    rax,[rbp-0x20]
  402a99:	49 89 c0             	mov    r8,rax
  402a9c:	b9 20 b0 47 00       	mov    ecx,0x47b020
  402aa1:	ba 52 00 00 00       	mov    edx,0x52
  402aa6:	be 1c 01 00 00       	mov    esi,0x11c
  402aab:	bf 00 b7 47 00       	mov    edi,0x47b700
  402ab0:	e8 5d f2 ff ff       	call   0x401d12
  402ab5:	c9                   	leave
  402ab6:	c3                   	ret
  402ab7:	55                   	push   rbp
  402ab8:	48 89 e5             	mov    rbp,rsp
  402abb:	48 81 ec 20 10 00 00 	sub    rsp,0x1020
  402ac2:	48 8d 45 e5          	lea    rax,[rbp-0x1b]
  402ac6:	ba 0e 00 00 00       	mov    edx,0xe
  402acb:	be 80 be 47 00       	mov    esi,0x47be80
  402ad0:	48 89 c7             	mov    rdi,rax
  402ad3:	e8 7c fd ff ff       	call   0x402854
  402ad8:	48 8d 8d e0 ef ff ff 	lea    rcx,[rbp-0x1020]
  402adf:	48 8d 45 e5          	lea    rax,[rbp-0x1b]
  402ae3:	ba ff 0f 00 00       	mov    edx,0xfff
  402ae8:	48 89 ce             	mov    rsi,rcx
  402aeb:	48 89 c7             	mov    rdi,rax
  402aee:	e8 fd 35 02 00       	call   0x4260f0
  402af3:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  402af7:	48 83 7d f8 00       	cmp    QWORD PTR [rbp-0x8],0x0
  402afc:	7e 5d                	jle    0x402b5b
  402afe:	48 8d 95 e0 ef ff ff 	lea    rdx,[rbp-0x1020]
  402b05:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  402b09:	48 01 d0             	add    rax,rdx
  402b0c:	c6 00 00             	mov    BYTE PTR [rax],0x0
  402b0f:	48 8d 85 e0 ef ff ff 	lea    rax,[rbp-0x1020]
  402b16:	48 89 c7             	mov    rdi,rax
  402b19:	e8 02 36 02 00       	call   0x426120
  402b1e:	48 8d 85 e0 ef ff ff 	lea    rax,[rbp-0x1020]
  402b25:	ba ed 01 00 00       	mov    edx,0x1ed
  402b2a:	be 41 02 00 00       	mov    esi,0x241
  402b2f:	48 89 c7             	mov    rdi,rax
  402b32:	b8 00 00 00 00       	mov    eax,0x0
  402b37:	e8 04 35 02 00       	call   0x426040
  402b3c:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
  402b3f:	83 7d f4 00          	cmp    DWORD PTR [rbp-0xc],0x0
  402b43:	78 17                	js     0x402b5c
  402b45:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  402b48:	89 c7                	mov    edi,eax
  402b4a:	e8 61 fd ff ff       	call   0x4028b0
  402b4f:	8b 45 f4             	mov    eax,DWORD PTR [rbp-0xc]
  402b52:	89 c7                	mov    edi,eax
  402b54:	e8 67 34 02 00       	call   0x425fc0
  402b59:	eb 01                	jmp    0x402b5c
  402b5b:	90                   	nop
  402b5c:	c9                   	leave
  402b5d:	c3                   	ret
  402b5e:	55                   	push   rbp
  402b5f:	48 89 e5             	mov    rbp,rsp
  402b62:	48 81 ec d0 00 00 00 	sub    rsp,0xd0
  402b69:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  402b70:	c7 45 f8 58 20 40 00 	mov    DWORD PTR [rbp-0x8],0x402058
  402b77:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [rbp-0xc],0x0
  402b7e:	c7 45 f0 00 00 00 00 	mov    DWORD PTR [rbp-0x10],0x0
  402b85:	c7 85 3c ff ff ff d6 	mov    DWORD PTR [rbp-0xc4],0x9e2d13d6
  402b8c:	13 2d 9e 
  402b8f:	8b 85 3c ff ff ff    	mov    eax,DWORD PTR [rbp-0xc4]
  402b95:	35 f7 13 2d 9e       	xor    eax,0x9e2d13f7
  402b9a:	0f b6 c0             	movzx  eax,al
  402b9d:	83 f8 73             	cmp    eax,0x73
  402ba0:	0f 84 75 01 00 00    	je     0x402d1b
  402ba6:	83 f8 73             	cmp    eax,0x73
  402ba9:	0f 87 b8 03 00 00    	ja     0x402f67
  402baf:	83 f8 6f             	cmp    eax,0x6f
  402bb2:	0f 84 a5 03 00 00    	je     0x402f5d
  402bb8:	83 f8 6f             	cmp    eax,0x6f
  402bbb:	0f 87 a6 03 00 00    	ja     0x402f67
  402bc1:	83 f8 68             	cmp    eax,0x68
  402bc4:	0f 84 20 02 00 00    	je     0x402dea
  402bca:	83 f8 68             	cmp    eax,0x68
  402bcd:	0f 87 94 03 00 00    	ja     0x402f67
  402bd3:	83 f8 5c             	cmp    eax,0x5c
  402bd6:	0f 84 b7 01 00 00    	je     0x402d93
  402bdc:	83 f8 5c             	cmp    eax,0x5c
  402bdf:	0f 87 82 03 00 00    	ja     0x402f67
  402be5:	83 f8 55             	cmp    eax,0x55
  402be8:	0f 84 bc 02 00 00    	je     0x402eaa
  402bee:	83 f8 55             	cmp    eax,0x55
  402bf1:	0f 87 70 03 00 00    	ja     0x402f67
  402bf7:	83 f8 4b             	cmp    eax,0x4b
  402bfa:	0f 84 ea 00 00 00    	je     0x402cea
  402c00:	83 f8 4b             	cmp    eax,0x4b
  402c03:	0f 87 5e 03 00 00    	ja     0x402f67
  402c09:	83 f8 44             	cmp    eax,0x44
  402c0c:	0f 84 1b 02 00 00    	je     0x402e2d
  402c12:	83 f8 44             	cmp    eax,0x44
  402c15:	0f 87 4c 03 00 00    	ja     0x402f67
  402c1b:	83 f8 39             	cmp    eax,0x39
  402c1e:	0f 84 40 01 00 00    	je     0x402d64
  402c24:	83 f8 39             	cmp    eax,0x39
  402c27:	0f 87 3a 03 00 00    	ja     0x402f67
  402c2d:	83 f8 31             	cmp    eax,0x31
  402c30:	0f 84 a5 02 00 00    	je     0x402edb
  402c36:	83 f8 31             	cmp    eax,0x31
  402c39:	0f 87 28 03 00 00    	ja     0x402f67
  402c3f:	83 f8 2e             	cmp    eax,0x2e
  402c42:	0f 84 c7 01 00 00    	je     0x402e0f
  402c48:	83 f8 2e             	cmp    eax,0x2e
  402c4b:	0f 87 16 03 00 00    	ja     0x402f67
  402c51:	83 f8 27             	cmp    eax,0x27
  402c54:	0f 84 e5 02 00 00    	je     0x402f3f
  402c5a:	83 f8 27             	cmp    eax,0x27
  402c5d:	0f 87 04 03 00 00    	ja     0x402f67
  402c63:	83 f8 21             	cmp    eax,0x21
  402c66:	74 44                	je     0x402cac
  402c68:	83 f8 21             	cmp    eax,0x21
  402c6b:	0f 87 f6 02 00 00    	ja     0x402f67
  402c71:	83 f8 18             	cmp    eax,0x18
  402c74:	0f 84 f8 01 00 00    	je     0x402e72
  402c7a:	83 f8 18             	cmp    eax,0x18
  402c7d:	0f 87 e4 02 00 00    	ja     0x402f67
  402c83:	83 f8 12             	cmp    eax,0x12
  402c86:	0f 84 bd 00 00 00    	je     0x402d49
  402c8c:	83 f8 12             	cmp    eax,0x12
  402c8f:	0f 87 d2 02 00 00    	ja     0x402f67
  402c95:	83 f8 03             	cmp    eax,0x3
  402c98:	0f 84 7e 02 00 00    	je     0x402f1c
  402c9e:	83 f8 07             	cmp    eax,0x7
  402ca1:	0f 84 1e 01 00 00    	je     0x402dc5
  402ca7:	e9 bb 02 00 00       	jmp    0x402f67
  402cac:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  402caf:	89 c6                	mov    esi,eax
  402cb1:	bf 94 bc 47 00       	mov    edi,0x47bc94
  402cb6:	e8 93 f0 ff ff       	call   0x401d4e
  402cbb:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
  402cbe:	8b 05 f0 b6 0a 00    	mov    eax,DWORD PTR [rip+0xab6f0]        # 0x4ae3b4
  402cc4:	33 45 fc             	xor    eax,DWORD PTR [rbp-0x4]
  402cc7:	89 05 e7 b6 0a 00    	mov    DWORD PTR [rip+0xab6e7],eax        # 0x4ae3b4
  402ccd:	8b 15 dd b6 0a 00    	mov    edx,DWORD PTR [rip+0xab6dd]        # 0x4ae3b0
  402cd3:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  402cd6:	01 d0                	add    eax,edx
  402cd8:	31 45 f8             	xor    DWORD PTR [rbp-0x8],eax
  402cdb:	c7 85 3c ff ff ff bc 	mov    DWORD PTR [rbp-0xc4],0x9e2d13bc
  402ce2:	13 2d 9e 
  402ce5:	e9 96 02 00 00       	jmp    0x402f80
  402cea:	8b 05 c0 b6 0a 00    	mov    eax,DWORD PTR [rip+0xab6c0]        # 0x4ae3b0
  402cf0:	33 45 fc             	xor    eax,DWORD PTR [rbp-0x4]
  402cf3:	33 45 f8             	xor    eax,DWORD PTR [rbp-0x8]
  402cf6:	3d 67 e6 09 6a       	cmp    eax,0x6a09e667
  402cfb:	75 0f                	jne    0x402d0c
  402cfd:	c7 85 3c ff ff ff 84 	mov    DWORD PTR [rbp-0xc4],0x9e2d1384
  402d04:	13 2d 9e 
  402d07:	e9 74 02 00 00       	jmp    0x402f80
  402d0c:	c7 85 3c ff ff ff e5 	mov    DWORD PTR [rbp-0xc4],0x9e2d13e5
  402d13:	13 2d 9e 
  402d16:	e9 65 02 00 00       	jmp    0x402f80
  402d1b:	bf a6 bc 47 00       	mov    edi,0x47bca6
  402d20:	e8 fd f7 ff ff       	call   0x402522
  402d25:	8b 15 89 b6 0a 00    	mov    edx,DWORD PTR [rip+0xab689]        # 0x4ae3b4
  402d2b:	31 d0                	xor    eax,edx
  402d2d:	89 05 81 b6 0a 00    	mov    DWORD PTR [rip+0xab681],eax        # 0x4ae3b4
  402d33:	81 45 f8 df 9b 57 13 	add    DWORD PTR [rbp-0x8],0x13579bdf
  402d3a:	c7 85 3c ff ff ff e5 	mov    DWORD PTR [rbp-0xc4],0x9e2d13e5
  402d41:	13 2d 9e 
  402d44:	e9 37 02 00 00       	jmp    0x402f80
  402d49:	e8 69 fd ff ff       	call   0x402ab7
  402d4e:	81 75 f8 e0 ac 68 24 	xor    DWORD PTR [rbp-0x8],0x2468ace0
  402d55:	c7 85 3c ff ff ff ce 	mov    DWORD PTR [rbp-0xc4],0x9e2d13ce
  402d5c:	13 2d 9e 
  402d5f:	e9 1c 02 00 00       	jmp    0x402f80
  402d64:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  402d68:	ba 16 00 00 00       	mov    edx,0x16
  402d6d:	be 90 be 47 00       	mov    esi,0x47be90
  402d72:	48 89 c7             	mov    rdi,rax
  402d75:	e8 da fa ff ff       	call   0x402854
  402d7a:	0f b6 45 d0          	movzx  eax,BYTE PTR [rbp-0x30]
  402d7e:	0f b6 c0             	movzx  eax,al
  402d81:	01 45 f8             	add    DWORD PTR [rbp-0x8],eax
  402d84:	c7 85 3c ff ff ff ab 	mov    DWORD PTR [rbp-0xc4],0x9e2d13ab
  402d8b:	13 2d 9e 
  402d8e:	e9 ed 01 00 00       	jmp    0x402f80
  402d93:	48 8d 45 c4          	lea    rax,[rbp-0x3c]
  402d97:	ba 0b 00 00 00       	mov    edx,0xb
  402d9c:	be a8 be 47 00       	mov    esi,0x47bea8
  402da1:	48 89 c7             	mov    rdi,rax
  402da4:	e8 ab fa ff ff       	call   0x402854
  402da9:	0f b6 45 c4          	movzx  eax,BYTE PTR [rbp-0x3c]
  402dad:	0f b6 c0             	movzx  eax,al
  402db0:	c1 e0 08             	shl    eax,0x8
  402db3:	31 45 f8             	xor    DWORD PTR [rbp-0x8],eax
  402db6:	c7 85 3c ff ff ff f0 	mov    DWORD PTR [rbp-0xc4],0x9e2d13f0
  402dbd:	13 2d 9e 
  402dc0:	e9 bb 01 00 00       	jmp    0x402f80
  402dc5:	48 8d 45 d0          	lea    rax,[rbp-0x30]
  402dc9:	48 89 c6             	mov    rsi,rax
  402dcc:	bf b7 bc 47 00       	mov    edi,0x47bcb7
  402dd1:	b8 00 00 00 00       	mov    eax,0x0
  402dd6:	e8 35 36 00 00       	call   0x406410
  402ddb:	c7 85 3c ff ff ff 9f 	mov    DWORD PTR [rbp-0xc4],0x9e2d139f
  402de2:	13 2d 9e 
  402de5:	e9 96 01 00 00       	jmp    0x402f80
  402dea:	48 8d 45 c4          	lea    rax,[rbp-0x3c]
  402dee:	48 89 c6             	mov    rsi,rax
  402df1:	bf b7 bc 47 00       	mov    edi,0x47bcb7
  402df6:	b8 00 00 00 00       	mov    eax,0x0
  402dfb:	e8 10 36 00 00       	call   0x406410
  402e00:	c7 85 3c ff ff ff d9 	mov    DWORD PTR [rbp-0xc4],0x9e2d13d9
  402e07:	13 2d 9e 
  402e0a:	e9 71 01 00 00       	jmp    0x402f80
  402e0f:	48 8b 05 7a a1 0a 00 	mov    rax,QWORD PTR [rip+0xaa17a]        # 0x4acf90
  402e16:	48 89 c7             	mov    rdi,rax
  402e19:	e8 b2 8f 00 00       	call   0x40bdd0
  402e1e:	c7 85 3c ff ff ff b3 	mov    DWORD PTR [rbp-0xc4],0x9e2d13b3
  402e25:	13 2d 9e 
  402e28:	e9 53 01 00 00       	jmp    0x402f80
  402e2d:	48 8b 15 64 a1 0a 00 	mov    rdx,QWORD PTR [rip+0xaa164]        # 0x4acf98
  402e34:	48 8d 85 40 ff ff ff 	lea    rax,[rbp-0xc0]
  402e3b:	be 80 00 00 00       	mov    esi,0x80
  402e40:	48 89 c7             	mov    rdi,rax
  402e43:	e8 08 91 00 00       	call   0x40bf50
  402e48:	48 85 c0             	test   rax,rax
  402e4b:	75 16                	jne    0x402e63
  402e4d:	c7 45 f0 01 00 00 00 	mov    DWORD PTR [rbp-0x10],0x1
  402e54:	c7 85 3c ff ff ff 98 	mov    DWORD PTR [rbp-0xc4],0x9e2d1398
  402e5b:	13 2d 9e 
  402e5e:	e9 1d 01 00 00       	jmp    0x402f80
  402e63:	c7 85 3c ff ff ff ef 	mov    DWORD PTR [rbp-0xc4],0x9e2d13ef
  402e6a:	13 2d 9e 
  402e6d:	e9 0e 01 00 00       	jmp    0x402f80
  402e72:	48 8d 85 40 ff ff ff 	lea    rax,[rbp-0xc0]
  402e79:	be ba bc 47 00       	mov    esi,0x47bcba
  402e7e:	48 89 c7             	mov    rdi,rax
  402e81:	e8 22 e2 ff ff       	call   0x4010a8
  402e86:	c6 84 05 40 ff ff ff 	mov    BYTE PTR [rbp+rax*1-0xc0],0x0
  402e8d:	00 
  402e8e:	0f b6 85 40 ff ff ff 	movzx  eax,BYTE PTR [rbp-0xc0]
  402e95:	0f b6 c0             	movzx  eax,al
  402e98:	31 45 f8             	xor    DWORD PTR [rbp-0x8],eax
  402e9b:	c7 85 3c ff ff ff a2 	mov    DWORD PTR [rbp-0xc4],0x9e2d13a2
  402ea2:	13 2d 9e 
  402ea5:	e9 d6 00 00 00       	jmp    0x402f80
  402eaa:	48 8d 85 40 ff ff ff 	lea    rax,[rbp-0xc0]
  402eb1:	48 89 c7             	mov    rdi,rax
  402eb4:	e8 64 fb ff ff       	call   0x402a1d
  402eb9:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
  402ebc:	8b 55 f4             	mov    edx,DWORD PTR [rbp-0xc]
  402ebf:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  402ec2:	01 d0                	add    eax,edx
  402ec4:	05 34 12 aa 55       	add    eax,0x55aa1234
  402ec9:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
  402ecc:	c7 85 3c ff ff ff c6 	mov    DWORD PTR [rbp-0xc4],0x9e2d13c6
  402ed3:	13 2d 9e 
  402ed6:	e9 a5 00 00 00       	jmp    0x402f80
  402edb:	83 7d f4 00          	cmp    DWORD PTR [rbp-0xc],0x0
  402edf:	74 07                	je     0x402ee8
  402ee1:	b8 bc bc 47 00       	mov    eax,0x47bcbc
  402ee6:	eb 05                	jmp    0x402eed
  402ee8:	b8 c0 bc 47 00       	mov    eax,0x47bcc0
  402eed:	48 89 c7             	mov    rdi,rax
  402ef0:	b8 00 00 00 00       	mov    eax,0x0
  402ef5:	e8 16 35 00 00       	call   0x406410
  402efa:	c7 45 f0 00 00 00 00 	mov    DWORD PTR [rbp-0x10],0x0
  402f01:	8b 05 ad b4 0a 00    	mov    eax,DWORD PTR [rip+0xab4ad]        # 0x4ae3b4
  402f07:	33 45 f8             	xor    eax,DWORD PTR [rbp-0x8]
  402f0a:	89 05 a4 b4 0a 00    	mov    DWORD PTR [rip+0xab4a4],eax        # 0x4ae3b4
  402f10:	c7 85 3c ff ff ff 98 	mov    DWORD PTR [rbp-0xc4],0x9e2d1398
  402f17:	13 2d 9e 
  402f1a:	eb 64                	jmp    0x402f80
  402f1c:	bf c4 bc 47 00       	mov    edi,0x47bcc4
  402f21:	e8 fc f5 ff ff       	call   0x402522
  402f26:	31 45 f8             	xor    DWORD PTR [rbp-0x8],eax
  402f29:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  402f2c:	c1 e8 05             	shr    eax,0x5
  402f2f:	83 e0 7f             	and    eax,0x7f
  402f32:	35 f7 13 2d 9e       	xor    eax,0x9e2d13f7
  402f37:	89 85 3c ff ff ff    	mov    DWORD PTR [rbp-0xc4],eax
  402f3d:	eb 41                	jmp    0x402f80
  402f3f:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
  402f42:	89 c6                	mov    esi,eax
  402f44:	bf d4 bc 47 00       	mov    edi,0x47bcd4
  402f49:	e8 00 ee ff ff       	call   0x401d4e
  402f4e:	01 45 fc             	add    DWORD PTR [rbp-0x4],eax
  402f51:	c7 85 3c ff ff ff a2 	mov    DWORD PTR [rbp-0xc4],0x9e2d13a2
  402f58:	13 2d 9e 
  402f5b:	eb 23                	jmp    0x402f80
  402f5d:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
  402f60:	89 c7                	mov    edi,eax
  402f62:	e8 f9 32 00 00       	call   0x406260
  402f67:	8b 85 3c ff ff ff    	mov    eax,DWORD PTR [rbp-0xc4]
  402f6d:	2d 51 b1 52 21       	sub    eax,0x2152b151
  402f72:	31 45 f8             	xor    DWORD PTR [rbp-0x8],eax
  402f75:	c7 85 3c ff ff ff e5 	mov    DWORD PTR [rbp-0xc4],0x9e2d13e5
  402f7c:	13 2d 9e 
  402f7f:	90                   	nop
  402f80:	e9 0a fc ff ff       	jmp    0x402b8f
